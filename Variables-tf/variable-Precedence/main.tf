terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
resource "aws_instance" "webapp-1" {
  instance_type = var.instance_type
  ami = var.wefapp-ami
  
}