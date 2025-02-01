variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "first_name" {
  description = "First name of the user"
  type        = string
}

variable "last_name" {
  description = "Last name of the user"
  type        = string
}

variable "group_name" {
  description = "IAM Group name"
  type        = string
  default     = "EC2_VPC_Admins"
}

variable "policy_file_path" {
  description = "Path to the JSON policy file"
  type        = string
  default     = "policy.json"
}