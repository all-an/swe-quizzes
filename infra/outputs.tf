output "frontend_url" {
  description = "Open this in the browser — the S3-hosted Angular app."
  value       = "http://${aws_s3_bucket.frontend.bucket}.s3.localhost.floci.io:4566"
}

output "backend_url" {
  description = "API base URL the frontend calls (ALB listener)."
  value       = "http://localhost:${var.backend_listener_port}"
}

output "frontend_bucket" {
  value = aws_s3_bucket.frontend.bucket
}

output "ecr_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "rds_endpoint" {
  value = "${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}"
}
