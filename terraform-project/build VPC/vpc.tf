provider "aws"{
    region = "eu-west-3"
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

data "aws_availability_zones" "available" {}

module "myapp-vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "2.64.0"
  
}
