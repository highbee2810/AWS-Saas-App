variable "vpc_cidr" {
    description = "The name of thr VPC to be creates"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
    description = "the first public subnet cidr block range"
    type = string
    default = "10.0.0.0/24"
}
variable "public_subnet_cidr_2" {
    description = "the second public subnet cidr block range"
    type = string
    default = "10.0.1.0/24"
}
variable "private_subnet_cidr1" {
    description = "the first private subnet cidr block range"
    type = string
    default = "10.0.3.0/24"
    }
variable "private_subnet_cidr2" {
    description = "the second private subnet cidr block range"
    type = string
    default = "10.0.4.0/24"
    }