output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}
output "public_subnet_id" {
    description = "The public subnet cidr range"
    value = aws_subnet.public_subnet.id
}