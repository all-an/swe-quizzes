variable "floci_endpoint" {
  description = "Floci endpoint that emulates all AWS services."
  type        = string
  default     = "http://localhost:4566"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Floci ships a default VPC and three default subnets. Using them keeps the
# stack close to the spike and avoids VPC-creation quirks in the emulator.
variable "vpc_id" {
  type    = string
  default = "vpc-default"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-default-a", "subnet-default-b"]
}

variable "frontend_bucket" {
  type    = string
  default = "swe-quizzes-frontend"
}

variable "frontend_origin" {
  description = "Public origin of the S3-hosted frontend, allowed by the backend CORS config."
  type        = string
  default     = "http://swe-quizzes-frontend.s3-website.localhost.floci.io:4566"
}

variable "backend_listener_port" {
  description = "ALB listener port the browser uses to reach the API."
  type        = number
  default     = 8081
}

variable "backend_container_port" {
  description = "Port the Spring Boot container listens on."
  type        = number
  default     = 8080
}

variable "db_name" {
  type    = string
  default = "swequizzes"
}

variable "db_username" {
  type    = string
  default = "swequizzes"
}

variable "db_password" {
  type      = string
  default   = "swequizzes"
  sensitive = true
}
