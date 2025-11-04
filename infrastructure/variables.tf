variable "vpc_cidr" {
    description = "The name of thr VPC to be creates"
    type = string
    default = "10.0.0.0/16"
}
variable "public_subnet_cidr_1" {
    description = "the first public subnet cidr block range"
    type = string
    default = "10.0.0.1/24"
}
variable "public_subnet_cidr_2" {
    description = "the second public subnet cidr block range"
    type = string
    default = "10.0.0.2/24"
}