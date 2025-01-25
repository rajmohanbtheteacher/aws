terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider aws {
	region = var.region
}

resource "aws_security_group" "demo_sg" {
  name = "demo_sg_terraform"
  description = "Demo Security Group Creation Using Terraform"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Security Group - Terraform"
  }
}

# Define Ingress Rule for Web Service
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_web" {
  security_group_id = aws_security_group.demo_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.app_web_port
  to_port = var.app_web_port
  ip_protocol = var.ip_protocol

}
# Define Ingress Rule for SSH
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_ssh" {
  security_group_id = aws_security_group.demo_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.app_ssh_port
  to_port = var.app_ssh_port
  ip_protocol = var.ip_protocol

}
# Define Egress Rule for All Traffic
resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  security_group_id = aws_security_group.demo_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = var.allow_all
}