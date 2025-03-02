# Output
output "bastion_public_ip" {
  description = "Public IP of the Bastion host"
  value       = aws_instance.bastion.public_ip
}

output "s3_bucket_name" {
  description = "S3 Bucket for Terraform state"
  value       = "become-techgeek-tfstate-demo"
}

output "current_timestamp" {
  description = "Current timestamp"
  value       = timestamp()
}

output "formatted_date" {
  description = "Formatted date for logs"
  value       = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
}

output "rds_endpoint" {
  description = "RDS endpoint details"
  value       = aws_db_instance.rds.endpoint
}

output "rds_port" {
  description = "RDS port number"
  value       = aws_db_instance.rds.port
}


output "nat_gateway_ip" {
  description = "NAT Gateway Elastic IP"
  value       = aws_eip.nat.public_ip
}