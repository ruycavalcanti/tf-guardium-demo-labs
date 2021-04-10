locals {
  common_tags = {
    Terraform = "true"
    Environment = "demo"
  }
}


resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags =  {
    Name = "lab-vpc",
    Terraform = "true",
    Environment = "demo"
  }
}

resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "lab-vpc-igw"
  }
}

resource "aws_subnet" "main_public_subnet" {
  count = length(var.public_subnets)
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = count.index == 0 ? true : false

  tags = {
    Name = "lab-vpc-public-subnet${count.index + 1}"
  }
}

resource "aws_subnet" "main_private_subnet" {
  count = length(var.private_subnets)
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.azs[count.index + 1]
  map_public_ip_on_launch = count.index == 0 ? true : false

  tags = {
    Name = "lab-vpc-private-subnet${count.index + 1}"
  }
}

resource "aws_route_table" "main_public_route_table" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }

  tags = {
    Name = "lab-vpc-public-route-table${count.index + 1}"
  }
}

resource "aws_route_table" "main_private_route_table" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "lab-vpc-private-route-table${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count = length(var.public_subnets)
  subnet_id      = aws_subnet.main_public_subnet[count.index].id
  route_table_id = aws_route_table.main_public_route_table[count.index].id
}

resource "aws_route_table_association" "private_rt_assoc" {
  count = length(var.private_subnets)
  subnet_id      = aws_subnet.main_private_subnet[count.index].id
  route_table_id = aws_route_table.main_private_route_table[count.index].id
}
