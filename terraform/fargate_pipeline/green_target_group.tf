resource "aws_lb_target_group" "green" {
  name     = "my-green-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  target_type = "ip"

  deregistration_delay = 10

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    protocol            = "HTTP"
  }
}
