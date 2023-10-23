data "template_file" "blue_template" {
  template = file("${path.module}/user-data.sh.tpl")
  vars = {
    version = "Blue Version"
    color   = "lightblue"
  }
}

resource "aws_launch_template" "blue_template" {
 
  name_prefix            = "blue_template"
  image_id               = data.aws_ami.aws_basic_linux.id
  instance_type          = var.ec2_type
  key_name = var.keypair_rwb
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  user_data              = base64encode(data.template_file.blue_template.rendered)

#   network_interfaces {
#   security_groups = [aws_security_group.lb_sg.id]
#   associate_public_ip_address = true
#   delete_on_termination       = true 
# }

  iam_instance_profile {
    name = aws_iam_instance_profile.rwb_profile.name
  }
}

resource "aws_autoscaling_group" "blue" {
  name                = "blue_group"
  desired_capacity    = 3
  max_size            = 4
  min_size            = 2
  health_check_type   = "ELB"
  force_delete        = true
  vpc_zone_identifier = [aws_subnet.private_abc["private_a"].id,aws_subnet.private_abc["private_b"].id,aws_subnet.private_abc["private_c"].id]

  launch_template {
    id      = aws_launch_template.blue_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Red_White_Blue"
    propagate_at_launch = true
  }

  timeouts {
    delete = "5m"
  }
}

resource "aws_autoscaling_policy" "rwb_policy" {
  name                   = "rwb-scaling-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.blue.name
}