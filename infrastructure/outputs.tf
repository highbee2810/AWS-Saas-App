output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}
output "public_subnet_id" {
    description = "The first public subnet id"
    value = aws_subnet.public_subnet1.id
}
output "public_subnet_id2" {
    description = "The second public subnet id"
    value = aws_subnet.public_subnet2.id
}
output "private_subnet_id1" {
    description = "The first private subnet id"
    value = aws_subnet.private.id
}
output "private_subnet_id2" {
    description = "The first private subnet id"
    value = aws_subnet.private2.id
}