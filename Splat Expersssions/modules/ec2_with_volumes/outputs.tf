output "instance_ids" {
  value = [for instance in aws_instance.websrv : instance.id]
}

output "public_ips" {
  value = [for instance in aws_instance.websrv : instance.public_ip]
}