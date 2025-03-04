
# CIDR Block Selection Based on Environment using a function
locals {
  vpc_cidr = lookup({
    production = "188.1.0.0/16"
    dev        = "189.2.0.0/16"
    stage      = "11.0.0.0/16"
  }, var.environment, "11.0.0.0/16")
}

# Fetch Availability Zones
data "aws_availability_zones" "available" {}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Create Private & Public Subnets using Loops
# Create Private Subnets (3 in different AZs) - Fixed CIDR Calculation
resource "aws_subnet" "private" {
  count = 3

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(local.vpc_cidr, 8, count.index) # Adjusted bit size for /24 subnets
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
  }
}

# Create Public Subnets (2 in different AZs) - Fixed CIDR Calculation
resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(local.vpc_cidr, 8, count.index + 100) # Adjusted bit size to prevent conflict
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-${count.index + 1}"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# Route Tables (Public and Private)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

# Routes for Internet Access
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# NAT Gateway Setup
resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.nat.id

  tags = {
    Name = "${var.environment}-nat"
  }
}

# Route Private Subnets to NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associate Subnets to Route Tables using Loops
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Security Groups (ALB & Private Instances)
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = [80, 443]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-alb-sg"
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = [80, 443]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.alb_sg.id]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-private-sg"
  }
}

# Application Load Balancer (ALB)
resource "aws_lb" "alb" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = flatten(aws_subnet.public[*].id)  # Using all public subnets

  tags = {
    Name = "${var.environment}-alb"
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "tg" {
  name     = "${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"  # Ensures instance-based registration (required for ALB)

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

# ALB Listener (Forward traffic to Target Group)
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Auto Scaling Group with Loops
resource "aws_launch_template" "asg_lt" {
  name_prefix   = "${var.environment}-lt"
  image_id      = "ami-09c918c6f7ecc32ef" # Custom AMI
  instance_type = "t3.micro"

  network_interfaces {
    security_groups = [aws_security_group.private_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-instance"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns   = [aws_lb_target_group.tg.arn]  # Ensures ASG instances are attached
  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }
}