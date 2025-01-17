terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Ensure you're using a recent version
    }
  }

  required_version = ">= 1.5.0"
}

# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

# Fetch the Existing VPC by Name or ID
data "aws_vpc" "existing" {
  filter {
    name = "tag:Name"
    values = ["ue1-prod-vpc"]  # Replace with your VPC name
  }
}


resource "aws_security_group" "demo_sg" {
  name = "demo_sg_terraform"
  description = "Demo Security Group Creation Using Terraform"
  vpc_id      = data.aws_vpc.existing.id

  tags = {
    Name = "Security Group - Terraform"
  }
}

# Define Ingress Rule for Web Service
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_web" {
  security_group_id = aws_security_group.demo_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = 6

}
# Define Ingress Rule for SSH
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_ssh" {
  security_group_id = aws_security_group.demo_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  ip_protocol = 6

}
# Define Egress Rule for All Traffic
resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  security_group_id = aws_security_group.demo_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}