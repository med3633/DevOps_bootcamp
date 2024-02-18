#working directory 
# provider = import librarry
provider "aws" {
    # pass configuration to connect to our aws account 
    # aws configure to be connect locally 
    region = "us-east-1"
    # Dn't hard-credentials directly in the configuration file 
    access_key = "ASIASKI3TMQ7F64MJO3P"
    secret_key = "PKZOaIJdYYioHQyOxO6Q4rRPQfWsepeUHJx/IBep"
}
# resource/data = function call of library
# create rzsource name and variable of this ressource
resource "aws_vpc" "dev-vpc" {
    # ip range 
    cidr_block = "10.0.0.0/16"
    # tags key-value pair 
    tags = {
      Name : "development",
      vpc_env: "dev "
    }
  
}
## 1 methode
# create subnet inside vpc
resource "aws_subnet" "dev-subnet-1" {
    #difne the place of the subnet 
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = "10.0.10.0/24" 
    # in wich AZ
    availability_zone = "us-east-1"
    tags = {
      Name : "subnet-1-dev" 
    }  
}
# 2 methode of default vpc
#provider have two components =>data=>query the existance ressources  , resource
data "aws_vpc" "existing_vpc"  {
    # arguments = parameters of function
  # arguments = for filter query (wich vpc u want)
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc
  cidr_block = "172.31.48.0/24"
  availability_zone = "us-east-1"
}

# to destroy specific resource 
# terraform destroy -target <type>.<name>
## for exple 
## terraform destroy -target aws_subnet.dev-subnet-2