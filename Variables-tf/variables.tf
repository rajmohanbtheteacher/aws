variable "vpc_id" {
  default = "vpc-0ddd9a547674d4320"
}
variable "region" {
  default = "us-east-1"
}

variable "app_web_port" {
  default = "80"
}

variable "app_ssh_port" {
  default = "22"
}

variable "ip_protocol" {
  default = "tcp"
}
variable "allow_all" {
  default = "-1"
}