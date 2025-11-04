provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "Saas_VPC"
    }
}
resource "aws_subnet" "public_subnet" {
  vpc_id = var.vpc_cidr
  cidr_block = var.public_subnet_cidr_1
availability_zone = "us-east-2a"
  tags = {
    Name = " first Public_Subnet"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id = var.vpc_cidr
  cidr_block = var.public_subnet_cidr_2
availability_zone = "us-east-2b"
  tags = {
    Name = " second Public_Subnet"
  }
}