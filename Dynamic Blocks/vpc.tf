# 1. VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "MainVPC"
  }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "MainIGW"
  }
}

# 3. Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "PublicRT"
  }
}

# 4. Internet Route
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# 5. Public Subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = "${var.aws_region}${element(["a", "b", "c"], count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

# 6. Route Table Association
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# 7. Security Group with Dynamic Ingress Rules
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow inbound HTTP, SSH"
  vpc_id      = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = var.ingress_ports
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
    Name = "WebSecurityGroup"
  }
}