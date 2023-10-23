# DATA SOURCE FOR AMI
data "aws_ami" "aws_basic_linux" {
  owners      = [var.aws_owner_id]
  most_recent = true
  filter {
    name   = "name"
    values = [var.aws_ami_name]
  }
}

data "aws_vpc" "main_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "public_a" {
  filter {
    name   = "tag:Name"
    values = [var.public_a_subnet_name]
  }
}

data "aws_subnet" "public_b" {
  filter {
    name   = "tag:Name"
    values = [var.public_b_subnet_name]
  }
}

data "aws_subnet" "public_c" {
  filter {
    name   = "tag:Name"
    values = [var.public_c_subnet_name]
  }
}

data "aws_nat_gateway" "rwb_ngw" {
  subnet_id = data.aws_subnet.public_a.id

  tags = {
    Name = "rwb_ngw"
  }
}

data "aws_internet_gateway" "lb_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }
}

# data "aws_subnet" "private_a" {
#   filter {
#     name   = "tag:Name"
#     values = [var.private_a_subnet_name]
#   }
# }

# resource "aws_subnet" "private_bc" {
#   for_each = {
#     private_b = "10.0.2.0/24"
#     private_c = "10.0.3.0/24"
#   }
#   vpc_id            = data.aws_vpc.main_vpc.id
#   cidr_block        = each.value
#   availability_zone = each.key == "private_b" ? "us-east-1b" : "us-east-1c"

#   tags = {
#     Name = each.key
#   }
# }

resource "aws_subnet" "private_abc" {
  for_each = {
    private_a = "10.0.50.0/24"
    private_b = "10.0.51.0/24"
    private_c = "10.0.52.0/24"
  }
  vpc_id            = data.aws_vpc.main_vpc.id
  cidr_block        = each.value
  availability_zone =  each.key == "private_a" ? "us-east-1a" : (each.key == "private_b" ? "us-east-1b" : "us-east-1c")
  tags = {
    Name = each.key
  }
}
