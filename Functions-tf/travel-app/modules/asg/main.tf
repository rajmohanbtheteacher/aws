resource "aws_launch_template" "travel_app_lt" {
  name_prefix   = "travel-app-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = base64encode(file("${path.module}/../../bootstrap/userdata.sh"))
}

resource "aws_autoscaling_group" "travel_asg" {
  desired_capacity     = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.travel_app_lt.id
    version = "$Latest"
  }
}