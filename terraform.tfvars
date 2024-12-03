region_name       = "us-east-1"
vpc_cidr_block    = "10.0.0.0/16"
subnet_cidr_block = "10.0.1.0/24"
subnet_az         = "us-east-1a"
vpc_tag           = "vpc-terra"
igw_tag           = "igw-terra"
subnet_tag        = "subnet-terra"
rt_cidr_block     = "0.0.0.0/0"
rt_tag            = "rt-terra"
ec2_az            = "us-east-1a"
ec2_type          = "t2.micro"
key_name          = "kube"