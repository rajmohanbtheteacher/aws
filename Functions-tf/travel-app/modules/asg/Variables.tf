variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for ASG"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnets"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
}