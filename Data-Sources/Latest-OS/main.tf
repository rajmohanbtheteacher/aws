data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
 
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web-demo" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.small"
  associate_public_ip_address = true
  
}