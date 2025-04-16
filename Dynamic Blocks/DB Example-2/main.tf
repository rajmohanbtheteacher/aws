module "ec2_with_ebs" {
  source            = "./modules/ec2_with_volumes"
  ami_id            = "ami-09c918c6f7ecc32ef"
  instance_type     = "t2.micro"
  subnet_id         = "subnet-076d80798351d7dca"
  ebs_volumes       = var.ebs_volumes
  security_group_ids = ["sg-02da7142db41a26c2"]
  name              = "JenkinsAgent"
}