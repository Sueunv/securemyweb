resource "aws_lb" "this" {
  name               = "three-tier-alb"
  internal            = false
  load_balancer_type  = "application"
  subnets             = var.subnet_ids
  security_groups     = [var.alb_sg_id]

  tags = {
    Name = "three-tier-alb"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "three-tier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.web_instance_id
  port             = 80
}

