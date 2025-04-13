# ec2-instance.tf Code to Deploy Ec2-Instance

resource "aws_instance" "web_server" {
  ami           = var.ami_id
  subnet_id = aws_subnet.tapp_public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  instance_type = var.instance_type
  tags = {
    Name = "WebServer"
    Environment = var.environment
  }
}