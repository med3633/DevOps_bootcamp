terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-1"
}
  

variable vpc_cidr_block {}
variable subnet_1_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable instance_type {}
variable ssh_key {}
variable my_ip {}
variable ssh_key_private { }

data "aws_ami" "amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
      name = "name"
      values = [ "amzn2-ami-hvm-*-x86_64-gp2" ]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }  
}
output "ami_id" {
    value = data.aws_ami.amazon-linux-image.id
}
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
      Name = "${var.env_prefix}-vpc"
    }
}
 
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_1_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }
  
}

resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [var.my_ip]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# resource "aws_route_table_association" "a-rtb-subnet" {
#   subnet_id = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_route_table.myapp-route-table.id
  
# }

resource "aws_key_pair" "ssh-key" {
  key_name = "myapp-key"
  public_key = file(var.ssh_key)
}

output "server-ip" {
  value = aws_instance.myapp-server.public_key
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.amazon-linux-image.id
  instance_type = var.instance_type
  key_name = "myapp-key"
  associate_public_ip_address = true
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.avail_zone

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
  user_data = <<EOF
                  #!/bin/bash
                  apt-get update && apt-get  install -y docker-ce 
                  systemctl start docker
                  usermod -aG docker ec2-user
                  docker run -p 8080:8080 nginx
              EOF
  
}

    # null_resource is a terraform provider give u a null resource type on local machine outside of EC2 instance

resource "null_resource" "configure_server" {
  # tell teraform when execute null_resource
   triggers = {
     trigger = aws_instance.myapp-server.public_ip
   }
     provisioner "local-exec" {
    # path of ansible conf
    working_dir = "C:/Users/USER/Desktop/docker && ansible/Ansible_docker"
    #ansible command
    command = "ansible-playbook --inventory ${aws_instane.myapp-server.public_ip}, --privaate-key ${var.ssh_key_private} --user ec2-user deploy-docker.yml "
     }
  
}
