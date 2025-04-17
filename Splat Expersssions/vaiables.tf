variable "ebs_volumes" {
  description = "List of EBS volume maps"
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
  }))
  default = [
    { device_name = "/dev/sdf", volume_size = 10, volume_type = "gp3" },
    { device_name = "/dev/sdg", volume_size = 20, volume_type = "gp3" },
    { device_name = "/dev/sdh", volume_size = 50, volume_type = "gp2" }
  ]
}
