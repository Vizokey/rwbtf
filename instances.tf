# ATTACH THE INSTANCE PROFILE TO THE PUBLIC INSTANCE
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.aws_basic_linux.id
  instance_type          = var.ec2_type
  subnet_id              = data.aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = var.keypair_rwb
  associate_public_ip_address = true
  
  

  tags = {
    Name = "bastion_host"
  }
}

# resource "aws_instance" "my_private_server" {
#   count                  = var.number_of_instances
#   ami                    = data.aws_ami.aws_basic_linux.id
#   instance_type          = var.ec2_type
#   subnet_id              = data.aws_subnet.private.id
#   vpc_security_group_ids = [aws_security_group.app_sg.id]
#   key_name               = var.keypair_rwb
#   iam_instance_profile   = aws_iam_instance_profile.rwb_profile
#   user_data              = file("user-data.sh.tpl")

#   tags = {
#     Name = "Red_White_Blue_${count.index + 1}"
#   }

# }