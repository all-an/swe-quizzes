#!/bin/bash
set -e

STATIC_DIR="backend/src/main/resources/static"

echo "==> Building Angular..."
cd frontend
npm ci
npm run build
cd ..

echo "==> Clearing old static files..."
rm -rf "$STATIC_DIR"
mkdir -p "$STATIC_DIR"

echo "==> Copying Angular dist to Spring Boot static folder..."
cp -r frontend/dist/frontend/browser/. "$STATIC_DIR"

echo "==> Building Spring Boot JAR..."
cd backend
mvn clean package -DskipTests
cd ..

echo ""
echo "Done. JAR is at: backend/target/swe-quizzes-0.0.1-SNAPSHOT.jar"
