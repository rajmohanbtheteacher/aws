# Outputs
# Fetch instances belonging to the Auto Scaling Group
data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.asg.name]
  }
}

# Fetch instance private IPs
output "private_instance_ips" {
  value = data.aws_instances.asg_instances.private_ips
}

# Fetch instance IDs
output "private_instance_ids" {
  value = data.aws_instances.asg_instances.ids
}

# ALB Public DNS Name
output "alb_dns" {
  value = aws_lb.alb.dns_name
}

# ALB Public IP
output "alb_public_ip" {
  value = aws_lb.alb.id
}