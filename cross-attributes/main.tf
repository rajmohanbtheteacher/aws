terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider aws {
	region = "us-east-1"
}

resource "aws_eip" "teraform-gen-eip" {
  domain           = "vpc"
  
}

# Fetch the Existing VPC by Name or ID
data "aws_vpc" "existing" {
  filter {
    name = "tag:Name"
    values = ["ue1-prod-vpc"]  # Replace with your VPC name
  }
}


resource "aws_security_group" "cross-attr-sg" {
  name = "Cross-attribute-demo-terraform"
  description = "Demo Security Group Creation Using Terraform"
  vpc_id      = data.aws_vpc.existing.id

  tags = {
    Name = "Security Group - Terraform"
  }
}

# Define Ingress Rule for Web Service
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_secure_web" {
  security_group_id = aws_security_group.cross-attr-sg.id
  cidr_ipv4 = "${aws_eip.teraform-gen-eip.public_ip}/32"
  from_port = 443
  to_port = 443
  ip_protocol = 6

}