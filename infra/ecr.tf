# Registry for the backend image. The deploy step builds and pushes :latest here.
resource "aws_ecr_repository" "backend" {
  name                 = "swe-quizzes-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
