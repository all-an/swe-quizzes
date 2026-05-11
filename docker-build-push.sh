#!/bin/bash
set -e

IMAGE="allan8tech/swe-quizzes:v1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Running build-dist.sh..."
./build-dist.sh

echo "==> Building Docker image: $IMAGE"
docker buildx build \
  --platform linux/amd64 \
  -f Dockerfile.render \
  -t "$IMAGE" \
  --load \
  .

echo "==> Pushing Docker image: $IMAGE"
docker push "$IMAGE"

echo ""
echo "Done. Pushed $IMAGE"
