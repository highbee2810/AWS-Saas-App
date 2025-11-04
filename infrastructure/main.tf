provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "Saas_VPC"
    }
}
resource "aws_subnet" "public_subnet1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_1
availability_zone = "us-east-2a"
  tags = {
    Name = " first Public_Subnet"
  }
  map_public_ip_on_launch = true
}
resource "aws_subnet" "public_subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_2
availability_zone = "us-east-2b"
  tags = {
    Name = " second Public_Subnet"
  }
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr1
availability_zone = "us-east-2a"
  tags = {
    Name = " first Private_Subnet"
  }
  
}
resource "aws_subnet" "private2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr2
availability_zone = "us-east-2b"
  tags = {
    Name = " second Private_Subnet"
  }
}
# creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Saas_IGW"
  }
}
# crating Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "Saas_NAT_EIP"
  }
}
# creating NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "Saas_NAT_GW"
  }
}
# creating Public Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Saas_Public_RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
}
}
# associating Private Subnets with Public Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id 
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id 
}

#create a route table for public subnets
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Saas_Public_Subnet_RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
  # associate public subnets with this route table
  resource "aws_route_table_association" "public_subnet1_association" {
    subnet_id      = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.public_subnet_rt.id
  }
  resource "aws_route_table_association" "public_subnet2_association" {
    subnet_id      = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.public_subnet_rt.id
  }