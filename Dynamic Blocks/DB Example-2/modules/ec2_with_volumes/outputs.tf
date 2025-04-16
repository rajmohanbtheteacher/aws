output "instance_id" {
  value = aws_instance.websrv.id
}

output "public_ip" {
  value = aws_instance.websrv.public_ip
}