#This Code block is to create VPC and sub componenets

# Create VPC
resource "aws_vpc" "travelapp_vpc" {
  cidr_block = "10.0.0.0/16"
}
#Create Public Subnet
resource "aws_subnet" "tapp_public_subnet" {
  vpc_id                  = aws_vpc.travelapp_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Create Internet Gateway
resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.travelapp_vpc.id

  tags = {
    Name = "main-igw"
  }
}

#Create Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.travelapp_vpc.id

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

#  Create Route Table & adding Route for Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.travelapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associating Public Subnet with Route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.tapp_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
