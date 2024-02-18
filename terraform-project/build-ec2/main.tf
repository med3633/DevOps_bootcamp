# setting the region
provider "aws" {
  region  = "us-west-1"
}
  
# terraform apply --auto-approve => no need information
 
variable vpc_cidr_block {}
variable subnet_1_cidr_block {}
variable avail_zone {}
# env =>prod, dev,staging
variable env_prefix {}
variable instance_type {}
variable ssh_key {}
variable my_ip {}
# variable ssh_key_private { }


#1.create vpc
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
      Name = "${var.env_prefix}-vpc"
    }
}
#2.create subnet
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_1_cidr_block
    # 2.create subnet in one of AZ
    availability_zone = var.avail_zone
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    } 
}

# 1st methode
# 3. create Route Table & Internet Gateway (connect this VPC to the internet)
# create a new RT => one ip @ range vpc ROUTE INside vpc and second IGW handling all trafic from the internet 
# virtual route table
resource "aws_route_table" "myapp-route-table" {
  #RT inside VPC
  vpc_id = aws_vpc.myapp-vpc.id
  # define the route table
  route{
    # the first entry create auto
    #create the second entry IGW
    cidr_block = "0.0.0.0/0"
    # using igw inside the route table to tell the RT => hi plz , handle the request of VPC to the internet
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-rtb"
  }
  }
# virtual modem
 #3.Internet Gateway (connect this VPC to the internet)
resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id 
     tags = {
    Name: "${var.env_prefix}-igw"
  }
}
## 1st methode
## asociation RT to the subnet (subnet connected to the IGW)
resource "aws_route_table_association" "a-rtb-subnet"{
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}
 # 2sd methode use main RT that's why not be able to create RT  and association
#  resource "aws_default_route_table" "main-rtb" {
#   default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myapp-igw.id
#   }
#   tags = {
#     Name: "${var.env_prefix}-main-rtb"
#   }
#   }


#1st methode
#  4.create SG (firewall) in order to access to nginx from the browser
resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  # srv inside vpc associate to SG
  vpc_id = aws_vpc.myapp-vpc.id
# incoming traffic SSH / HTTP map 8080 nginx 
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      # allow ip
      cidr_blocks = [var.my_ip]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  #installation be fetch some ressource from the internet for exple nginx image
    egress  {
      #any port
        from_port = 0
        to_port = 0
        #any protocol
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
       # allow to access vpc endpoint
        prefix_list_ids = []
    }
    tags = {
        Name = "${var.env_prefix}-sg"
    } 
}
# #2st methode 
# #  an existing default sg => when create vpc , aws create default sg
# resource "aws_default_security_group" "myapp-sg" {
#   # srv inside vpc associate to SG
#   vpc_id = aws_vpc.myapp-vpc.id
# # incoming traffic SSH / HTTP map 8080 nginx 
#     ingress {
#       from_port = 22
#       to_port = 22
#       protocol = "tcp"
#       # allow ip
#       cidr_blocks = [var.my_ip]
#     }
#     ingress {
#         from_port = 8080
#         to_port = 8080
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#   #installation be fetch some ressource from the internet for exple nginx image
#     egress = {
#       #any port
#         from_port = 0
#         to_port = 0
#         #any protocol
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#        # allow to access vpc endpoint
#         prefix_list_ids = []
#     }
#     tags = {
#         Name = "${var.env_prefix}-default-sg"
#     } 
# }

   
 



# 5.create EC2
resource "aws_instance" "myapp-server" {
  # BASE ON IT this is the OS image 
  ami = "ami-0a3c3a20c09d6f377"
  instance_type = var.instance_type
  #optionnel
  subnet_id = aws_subnet.myapp-subnet-1.id
  #list of sg for EC2
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.avail_zone
  #public ip for this EC2
  associate_public_ip_address = true
  #ssh key to connect to EC2
  key_name = "myapp-key"

  tags = {
    Name = "${var.env_prefix}-server"
  }


  #add provisionner that call ansible command that execution on this instance
  # we have local-exec , remote-exec and file provissioner
  # we define local-exec because u execute ansible locally on owr laptop after a ressource is created
  #provisioner "local-exec" {
    # path of ansible conf
    #working_dir = "C:/Users/USER/Desktop/docker && ansible/Ansible_docker"
    #ansible command
  #  command = "ansible-playbook --inventory ${self.public_ip}, --privaate-key ${var.ssh_key_private} --user ec2-user deploy-docker.yml "
    # ansible needs to check first whether EC2 is ready 
    # add a play in ansible playboook if the remote instance accesible on ssh port 
  #}
# execute this command every time when new provision srv is created
#entrypoint attribut execut in EC2
  user_data = <<EOF
                  #!/bin/bash
                  apt-get update && apt-get  install -y docker-ce 
                  systemctl start docker
                  usermod -aG docker ec2-user
                  docker run -p 8080:8080 nginx
              EOF
  
}



# 5.2.create key pair with terraform instead to create mannualy
# resource "aws_key_pair" "ssh-key" {
#   key_name = "vokey"
#   # read fro the file lication
#   public_key = "${file(var.ssh_key)}"

# }
# output "server-ip" {
#   value = aws_key_pair.ssh-key
# }

    # null_resource is a terraform provider give u a null resource type on local machine outside of EC2 instance

# resource "null_resource" "configure_server" {
#   # tell teraform when execute null_resource
#    triggers = {
#      trigger = aws_instance.myapp-server.public_ip
#    }
#      provisioner "local-exec" {
#     # path of ansible conf
#     working_dir = "C:/Users/USER/Desktop/docker && ansible/Ansible_docker"
#     #ansible command
#     command = "ansible-playbook --inventory ${aws_instane.myapp-server.public_ip}, --privaate-key ${var.ssh_key_private} --user ec2-user deploy-docker.yml "
#      }
  
# }


## terraform khnows in which sequence the components must be created


## teraform state --show att