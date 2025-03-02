# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = "TF-Demo-VPC" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "TF-Demo-VPC-igw" }
}

# Subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "188.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { Name = "TF-Demo-VPC-public-subnet" }
}

resource "aws_subnet" "private_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "188.0.2.0/24"
  availability_zone       = "us-east-1b"
  tags = { Name = "TF-Demo-VPC-private-subnet" }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "188.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "private-subnet-b" }
}

# Security Group
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id
  name   = "TF-Demo-VPC-ec2-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id
  name   = "TF-Demo-VPC-bastion-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# NAT Gateway (For Private Subnet)
resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = { Name = "nat-gateway" }
}


# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-route-table" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Route Table for Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = { Name = "private-route-table" }
}

resource "aws_route_table_association" "private_assoc_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private_rt.id
}

# EC2 Instance with element function
resource "aws_instance" "web" {
  ami                    = "ami-005fc0f236362e99f"
  instance_type          = element(var.instance_types, 0)
  subnet_id              = aws_subnet.private_1a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = { Name = "web-server" }
}

# Bastion Host (Public Subnet with Public IP Enabled)
resource "aws_instance" "bastion" {
  ami                    = "ami-005fc0f236362e99f"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  tags = { Name = "TF-Demo-bastion-host" }
}

# Secrets for RDS
#resource "aws_secretsmanager_secret" "rds_secret_tf" {
#  name = "rds-credentials"
#}

#resource "aws_secretsmanager_secret_version" "rds_secret_value_tf" {
#  secret_id     = aws_secretsmanager_secret.rds_secret_tf.id
#  secret_string = jsonencode({
#    username = "admin",
#    password = "XXXXXX"
#  })
#}#
data "aws_secretsmanager_secret" "rds_secret" {
  name = "res_secret_tf"  # Replace with your actual secret name
}

data "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}
locals {
  rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_value.secret_string)
}

# RDS Instance
resource "aws_db_instance" "rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = lookup(var.instance_map, "rds", "db.t3.small")
  username           = local.rds_credentials["username"]
  password           = local.rds_credentials["password"]
  publicly_accessible = false
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.id
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
}
