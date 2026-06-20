# Running Floci — Local AWS Environment

[Floci](https://floci.io) is a free, open-source local AWS emulator. Running it in
Docker gives you AWS-shaped services on your machine (S3, DynamoDB, Lambda, RDS, etc.)
at `http://localhost:4566` — no AWS account, auth token, or feature gates.

> The bundled `floci/` folder is a checkout of Floci's source, kept here only for
> reviewing its functionality. To actually run a local AWS environment, use the
> published Docker image as described below — do **not** build/run from `floci/`.

## Quick Start

Create a `floci-compose.yml`:

```yaml
services:
  floci:
    image: floci/floci:latest
    ports:
      - "4566:4566"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

Start it:

```bash
docker compose -f floci-compose.yml up
```

Point your AWS tools at the local endpoint:

```bash
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
```

Any region works; credentials can be any non-empty values.

## Install the AWS CLI (optional)

Only needed if you want to drive Floci from the terminal — your app's AWS SDK does
not need it.

```bash
# macOS (Homebrew)
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install

# Verify
aws --version
```

## Verify

```bash
aws s3 mb s3://my-bucket
aws s3 ls
```

## Deploy swe-quizzes on Floci

This repo runs the whole app on Floci's emulated AWS — the Angular frontend on
**S3**, the Spring Boot backend on **ECS/Fargate** behind an **ALB**, and **RDS**
PostgreSQL — all provisioned with **Terraform** in `infra/`.

**Prerequisites:** Docker, the AWS CLI, and Terraform (`brew install hashicorp/tap/terraform`).

### First deploy

```bash
# 1. Start Floci (uses this repo's floci-compose.yml: ports, ECR path style, etc.)
docker compose -f floci-compose.yml up -d

# 2. Provision infra + build/push backend + build/sync frontend
./deploy-floci.sh
```

When it finishes it prints the URLs:

```
Frontend: http://swe-quizzes-frontend.s3.localhost.floci.io:4566
Backend:  http://localhost:8081
```

Open the **frontend** URL in your browser.

### Rebuild after code changes

Re-running the full pipeline is always safe:

```bash
./deploy-floci.sh
```

Or rebuild just the part you changed:

```bash
# Frontend only (Angular) — build and re-sync to S3
cd frontend && npm run build && cd ..
aws s3 sync frontend/dist/frontend/browser/ s3://swe-quizzes-frontend/ --delete

# Backend only (Spring Boot) — build, push, roll the ECS service
docker build -t swe-quizzes-backend:latest backend/
ECR=$(terraform -chdir=infra output -raw ecr_repository_url)
docker tag swe-quizzes-backend:latest "$ECR:latest"
docker push "$ECR:latest"
aws ecs update-service --cluster swe-quizzes --service swe-quizzes-backend --force-new-deployment
```

> The four `AWS_*` env vars from [Quick Start](#quick-start) must be exported in your
> shell for the `aws`/`terraform` commands above.

### Tear down

```bash
terraform -chdir=infra destroy        # remove the AWS resources
docker compose -f floci-compose.yml down
```

## Notes

- The Docker socket mount (`/var/run/docker.sock`) lets Floci spin up real
  Docker-backed services (Lambda, RDS, ElastiCache, etc.) where fidelity matters.
- Stop with `docker compose -f floci-compose.yml down`.
- Works as a drop-in for the AWS CLI, SDKs, Terraform, CDK, and OpenTofu — just
  set the endpoint to `http://localhost:4566`.
- **Recreating the Floci container resets its emulated cloud** (no control-plane
  persistence). After any `floci-compose.yml` change, re-run `./deploy-floci.sh`.
- The frontend is served over plain HTTP, which is not a "secure context", so
  browser APIs like `crypto.randomUUID` are unavailable — the app guards for this.
- Known limitation: deep-link refresh (e.g. `/quiz/1`) returns 404 because Floci
  doesn't apply the S3 `error_document` fallback for virtual-hosted GETs. Navigating
  from the home page works; only a direct sub-route reload 404s.
