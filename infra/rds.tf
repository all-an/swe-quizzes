# Floci runs this as a real postgres:16-alpine container. Flyway migrations
# (V1–V8) apply on backend startup against this instance.
resource "aws_db_instance" "postgres" {
  identifier        = "swe-quizzes-db"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  publicly_accessible = true
  skip_final_snapshot = true
}
