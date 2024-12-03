provider "aws" {
  region = "us-east-1"
}

# terraform {
#   backend "S3" {
#     name   = "bucket-name"
#     key    = "file to path"
#     region = "us-east-1"
#   }
# }

resource "aws_vpc" "vpc-learning" {
  enable_dns_hostnames = "true"
  cidr_block           = "10.0.0.0/16"

  tags = {
    name = "vpc-learning"
  }
}
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc-learning.id

  tags = {
    name = "IGW"
  }
}
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.vpc-learning.id
  cidr_block = "10.0.1.0/24"

  tags = {
    name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.vpc-learning.id
  cidr_block = "10.0.2.0/24"

  tags = {
    name = "public-subnet-2"
  }
}
resource "aws_subnet" "public-subnet-3" {
  vpc_id     = aws_vpc.vpc-learning.id
  cidr_block = "10.0.3.0/24"

  tags = {
    name = "public-subnet-3"
  }
}
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc-learning.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    name = "public-rt"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc-learning.id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "sg"
  }
}