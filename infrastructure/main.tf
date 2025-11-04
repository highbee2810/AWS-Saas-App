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
