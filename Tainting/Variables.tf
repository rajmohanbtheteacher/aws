variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "ingress_ports" {
  description = "List of allowed ingress ports"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "Travel App Custom AMI"
  default     = "ami-09c918c6f7ecc32ef"  # Replace with latest for your region
}