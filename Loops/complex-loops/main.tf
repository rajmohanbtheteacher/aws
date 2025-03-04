terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Define variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "environment_selection" {
  description = "Select environment: 1 for prod, 2 for dev, 3 for stage"
  type        = number
}

# Map the environment selection to actual environment names
locals {
  environment_map = {
    1 = "prod"
    2 = "dev"
    3 = "stage"
  }
  environment = lookup(local.environment_map, var.environment_selection, "dev")
}

# Define environment-specific settings
locals {
  vpc_cidr = (
    local.environment == "prod"  ? "10.0.0.0/16" :
    local.environment == "stage" ? "10.1.0.0/16" :
                                   "10.2.0.0/16")

  subnet_cidr_blocks = (
    local.environment == "prod"  ? ["10.0.1.0/24", "10.0.2.0/24"] :
    local.environment == "stage" ? ["10.1.1.0/24", "10.1.2.0/24"] :
                                   ["10.2.1.0/24", "10.2.2.0/24"])

  instance_type = (
    local.environment == "prod" ? "t3.large" : "t3.micro")
}

# Creating a VPC
resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.environment}-VPC"
  }
}

# Creating a security group to allow HTTP (80) traffic
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.environment}-web-sg"
  }
}

# Using a for loop to create subnet resources dynamically
resource "aws_subnet" "subnet" {
  count      = length(local.subnet_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = local.subnet_cidr_blocks[count.index]

  tags = {
    Name = "${local.environment}-subnet-${count.index + 1}"
  }
}

# Using instance deployment logic
resource "aws_instance" "web" {
  count         = 3
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = local.instance_type
  subnet_id     = element(aws_subnet.subnet[*].id, count.index % length(local.subnet_cidr_blocks))
  security_groups = [aws_security_group.web_sg.name]
  associate_public_ip_address = true
  tags = {
    Name = "${local.environment}-web-server-${count.index + 1}"
  }
}

# Fetch the latest Ubuntu AMI dynamically
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Output the created instance details
output "instance_ips" {
  description = "Public IP addresses of the instances"
  value       = aws_instance.web[*].public_ip
}
