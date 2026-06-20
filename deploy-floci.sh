#!/usr/bin/env bash
# Deploy swe-quizzes to AWS, emulated by Floci.
#
# Prerequisite: Floci is running with the published ports:
#   docker compose -f floci-compose.yml up -d
#
# Pipeline: terraform apply -> build & push backend image -> roll ECS ->
#           build frontend -> sync to S3.
set -euo pipefail

cd "$(dirname "$0")"

export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test

CLUSTER=swe-quizzes
SERVICE=swe-quizzes-backend

echo "==> [1/6] terraform apply"
terraform -chdir=infra apply -auto-approve

ECR_URL=$(terraform -chdir=infra output -raw ecr_repository_url)
BUCKET=$(terraform -chdir=infra output -raw frontend_bucket)
FRONTEND_URL=$(terraform -chdir=infra output -raw frontend_url)
BACKEND_URL=$(terraform -chdir=infra output -raw backend_url)

echo "==> [2/6] build backend image"
docker build -t swe-quizzes-backend:latest backend/

echo "==> [3/6] push image to ECR ($ECR_URL)"
aws ecr get-login-password | docker login --username AWS --password-stdin "${ECR_URL%%/*}" 2>/dev/null || true
docker tag swe-quizzes-backend:latest "$ECR_URL:latest"
docker push "$ECR_URL:latest"

echo "==> [4/6] roll ECS service to the new image"
aws ecs update-service --cluster "$CLUSTER" --service "$SERVICE" --force-new-deployment >/dev/null

echo "==> [5/6] build frontend"
( cd frontend && npm run build )

echo "==> [6/6] sync frontend to s3://$BUCKET"
aws s3 sync frontend/dist/frontend/browser/ "s3://$BUCKET/" --delete

echo
echo "Done."
echo "  Frontend: $FRONTEND_URL"
echo "  Backend:  $BACKEND_URL"
