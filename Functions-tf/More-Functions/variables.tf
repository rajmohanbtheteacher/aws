variable "aws_region" {}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "188.0.0.0/16"
}
variable "instance_types" {
  description = "List of instance types"
  default     = ["t2.micro", "t2.small", "t2.medium", "db.t3.micro"]
}

# Demonstrating lookup function
variable "instance_map" {
  description = "Mapping of instance types"
  default = {
    "dev"  = "t2.micro"
    "prod" = "t2.medium"
    "rds" = "db.t3.micro"
  }
}