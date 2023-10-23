resource "aws_lb" "application_lb" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [data.aws_subnet.public_a.id,data.aws_subnet.public_b.id,data.aws_subnet.public_c.id]

  access_logs {
    bucket        = "lbaccesslogz"
    prefix = "accesslog"
    enabled = true
  }

  tags = {
    Name = "application-lb"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.blue_target.arn
      }
    }
  }
}