output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "web_instance_public_ip" {
  value = aws_instance.web_server.public_ip
}