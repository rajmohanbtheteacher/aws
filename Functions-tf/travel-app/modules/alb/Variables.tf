
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_sg_id" {
  description = "Security group for ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnets"
  type        = list(string)
}