resource "aws_lb" "public" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.sg_alb_id]
}

resource "aws_lb" "internal" {
  name               = "internalapp-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnets
  security_groups    = [var.sg_alb_id]
}

resource "aws_lb_target_group" "proxy" {
  name        = "proxy-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "backend" {
  name        = "backend-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proxy.arn
  }
}

resource "aws_lb_listener" "internal_http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

resource "aws_lb_target_group_attachment" "proxy_attach" {
  count            = length(var.proxy_instance_ids)
  target_group_arn = aws_lb_target_group.proxy.arn
  target_id        = var.proxy_instance_ids[count.index]
  port             = 80
}

resource "aws_lb_target_group_attachment" "backend_attach" {
  count            = length(var.backend_instance_ids)
  target_group_arn = aws_lb_target_group.backend.arn
  target_id        = var.backend_instance_ids[count.index]
  port             = 80
}
