variable "aws_region" {
  description = "AWS Region"
  type        = string
}
variable "ami" {
  default = "ami-09c918c6f7ecc32ef"
}

variable "vpc_id" {}