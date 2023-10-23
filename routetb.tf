# resource "aws_route_table" "rwbtf" {
#   vpc_id = data.aws_vpc.main_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = data.aws_internet_gateway.lb_igw.id
#   }

#   tags = {
#     Name = "rwb"
#   }
# }

resource "aws_route_table" "rwb" {
  vpc_id = data.aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_nat_gateway.rwb_ngw.id
  }

  tags = {
    Name = "rwbb"
  }
}

# resource "aws_route_table_association" "igw" {
#   subnet_id      = data.aws_subnet.public_a.id
#   route_table_id = aws_route_table.rwbtf.id
# }

resource "aws_route_table_association" "ngw_a" {
  subnet_id      = aws_subnet.private_abc["private_a"].id
  route_table_id = aws_route_table.rwb.id
}

resource "aws_route_table_association" "ngw_b" {
  subnet_id      = aws_subnet.private_abc["private_b"].id
  route_table_id = aws_route_table.rwb.id
}

resource "aws_route_table_association" "ngw_c" {
  subnet_id      = aws_subnet.private_abc["private_c"].id
  route_table_id = aws_route_table.rwb.id
}