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

## Notes

- The Docker socket mount (`/var/run/docker.sock`) lets Floci spin up real
  Docker-backed services (Lambda, RDS, ElastiCache, etc.) where fidelity matters.
- Stop with `docker compose -f floci-compose.yml down`.
- Works as a drop-in for the AWS CLI, SDKs, Terraform, CDK, and OpenTofu — just
  set the endpoint to `http://localhost:4566`.
