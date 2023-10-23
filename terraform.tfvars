# ASSIGNING VALUE TO VARIABLES
aws_owner_id                = "137112412989"
aws_ami_name                = "amzn2-ami-kernel-5.10-hvm*"
vpc_name                    = "lb-vpc"
ec2_type                    = "t2.micro"
public_a_subnet_name        = "lb-subnet-public1-us-east-1a"
public_b_subnet_name        = "lb-subnet-public2-us-east-1b"
public_c_subnet_name        = "lb-subnet-public3-us-east-1c"
private_a_subnet_name       = "lb-subnet-private1-us-east-1a"
private_b_subnet_name       = "lb-subnet-private2-us-east-1b"
private_c_subnet_name       = "lb-subnet-private3-us-east-1c"
number_of_private_instances = 3
private_cidrs = [
  "10.0.22.0/24",
  "10.0.23.0/24"
]