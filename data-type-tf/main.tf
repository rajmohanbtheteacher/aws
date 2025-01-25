resource "aws_instance" "webapp1" {
  ami = var.ami-used
  security_groups = var.aws_vpc_security_groups_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = true

# Below To define tags for EC2 Instance, we are using MAPS data type 
tags = {
    Name = "TRAVEL-APP"
    Departmemt = "Tourism"
    Contact = "learn@rajmohanbtheteacher.in"
    Productowner = "Raj Mohan Bharathi"
  }

}


