resource "aws_ecs_cluster" "main" {
  name = "swe-quizzes"
}

# No execution role is set: the Floci spike confirmed ECS runs tasks and pulls
# images without one. The datasource points at the RDS instance; CORS allows the
# S3-hosted frontend origin.
resource "aws_ecs_task_definition" "backend" {
  family                   = "swe-quizzes-backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsonencode([{
    name      = "backend"
    image     = "${aws_ecr_repository.backend.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = var.backend_container_port
      protocol      = "tcp"
    }]
    environment = [
      {
        name  = "SPRING_DATASOURCE_URL"
        value = "jdbc:postgresql://${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/${var.db_name}"
      },
      { name = "SPRING_DATASOURCE_USERNAME", value = var.db_username },
      { name = "SPRING_DATASOURCE_PASSWORD", value = var.db_password },
      { name = "APP_CORS_ALLOWED_ORIGINS", value = var.frontend_origin },
    ]
  }])
}

resource "aws_ecs_service" "backend" {
  name            = "swe-quizzes-backend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
  }

  # Auto-registers the task IP into the target group (verified in the spike).
  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = var.backend_container_port
  }

  depends_on = [aws_lb_listener.backend]
}
