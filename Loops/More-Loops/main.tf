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
  default     = "us-east-1"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "tags" {
  description = "Tags to apply to the instances"
  type        = map(string)
  default = {
    Environment = "Production"
    Owner       = "DevOps Team"
  }
}

# Define a list of availability zones
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Using a for loop to create subnet resources dynamically
resource "aws_subnet" "subnet" {
  for_each = toset(var.availability_zones)
  vpc_id   = aws_vpc.main.id
  cidr_block = "10.0.${index(var.availability_zones, each.value)}.0/24"

  tags = {
    Name = "subnet-${each.value}"
  }
}

# Creating a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MainVPC"
  }
}

# If-Else Condition: Assigning instance type based on environment
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

locals {
  computed_instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"
}

# Using a Do-While Loop Alternative in Terraform (Simulated)
# Terraform doesn't have native do-while, so we use count with conditional logic
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = local.computed_instance_type
  subnet_id     = element(aws_subnet.subnet[*].id, count.index % length(var.availability_zones))

  tags = merge(
    var.tags,
    {
      Name = "web-server-${count.index + 1}"
    }
  )
}

# Fetch the latest Amazon Linux AMI dynamically
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

# Output the created instance details
output "instance_ips" {
  description = "Public IP addresses of the instances"
  value       = aws_instance.web[*].public_ip
}
