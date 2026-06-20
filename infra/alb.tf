# Application Load Balancer fronting the backend. The frontend lives on S3, so
# the ALB only carries API traffic and forwards everything to the backend.
resource "aws_lb" "backend" {
  name               = "swe-quizzes-alb"
  load_balancer_type = "application"
  internal           = false
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "backend" {
  name        = "swe-quizzes-tg"
  port        = var.backend_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/api/settings/public"
    protocol = "HTTP"
    matcher  = "200"
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = var.backend_listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
