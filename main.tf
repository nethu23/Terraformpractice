provider "aws" {
  region = var.region_name
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
  cidr_block           = var.vpc_cidr_block

  tags = {
    name = var.vpc_tag
  }
}
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc-learning.id

  tags = {
    name = var.igw_tag
  }
}
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.vpc-learning.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.subnet_az

  tags = {
    name = var.subnet_tag
  }
}

# resource "aws_subnet" "public-subnet-2" {
#   vpc_id     = aws_vpc.vpc-learning.id
#   cidr_block = "10.0.2.0/24"

#   tags = {
#     name = "public-subnet-2"
#   }
# }
# resource "aws_subnet" "public-subnet-3" {
#   vpc_id     = aws_vpc.vpc-learning.id
#   cidr_block = "10.0.3.0/24"

#   tags = {
#     name = "public-subnet-3"
#   }
# }
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc-learning.id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    name = var.rt_tag
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


resource "aws_instance" "web-1" {
  ami                         = "ami-0866a3c8686eaeeba"
  availability_zone           = var.ec2_az
  instance_type               = var.ec2_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public-subnet-1.id
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Prod-Server"
    Env        = "Prod"
    Owner      = "nethu"
    CostCenter = "ABCD"
  }
}