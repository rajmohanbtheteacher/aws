resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count      = length(var.private_subnets)
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnets[count.index]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}