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

# Create EC2 instances using a loop
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type

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
