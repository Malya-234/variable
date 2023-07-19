terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = 
}

resource "aws_vpc" "My_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "Pub_subnet" {
  vpc_id     = aws_vpc.My_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public_subnet"
  }
}

resource "aws_subnet" "Pri_subnet" {
  vpc_id     = aws_vpc.My_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private_subnet"
  }
}

#IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.My_vpc.id

  tags = {
    Name = "Internet gateway"
  }
}

# PUblic RT

resource "aws_route_table" "Pub_rt" {
  vpc_id = aws_vpc.My_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }
  tags = {
    Name = "Public_RT"
  }
}

# EIP

resource "aws_eip" "EIP" {
  vpc = true
  tags = {
    Name = "eip"
  }
}

# NAt 
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.Pri_subnet.id

  tags = {
    Name = "gw NAT"
  }
}

# Private RT
resource "aws_route_table" "Pri_rt" {
  vpc_id = aws_vpc.My_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT.id
  }
  tags = {
    Name = "Private_RT"
  }
}

# Security  Public grp

resource "aws_security_group" "Pubsg" {
  name        = "Pubsh"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.My_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public tcp"
  }
}

# Private Security group

resource "aws_security_group" "Private_sg" {
  name        = "Private_tcp"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.My_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["10.0.1.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PRivate_securtiy grp"
  }
}

# EC2 public instance

resource "aws_instance" "pub_instance" {
  ami                             = 
  instance_type                   = 
  availability_zone               = 
  associate_public_ip_address     = "true"
  vpc_security_group_ids          = [aws_security_group.Pubsg.id]
  subnet_id                       = aws_subnet.Pub_subnet.id 
  key_name                        = 
  
    tags = {
    Name = 
  }
}

# Private instance

resource "aws_instance" "pri_instance" {
  ami                             = 
  instance_type                   = 
  availability_zone               = 
  associate_public_ip_address     = "false"
  vpc_security_group_ids          = [aws_security_group.Private_sg.id]
  subnet_id                       = aws_subnet.Pri_subnet.id 
  key_name                        = 
  
    tags = {
    Name =
  }
}

