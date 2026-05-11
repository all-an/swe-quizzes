# Render Deploy Guide - Docker Image + Render Postgres

This guide deploys `swe-quizzes` to Render without GitHub CI/CD.

Flow:

1. Build the Angular frontend into the Spring Boot JAR locally.
2. Build a Docker image that contains only the JAR.
3. Push the Docker image to a container registry.
4. Create a Render Postgres database.
5. Create a Render Web Service from the existing Docker image.
6. Configure Spring Boot with Render Postgres environment variables.

Render docs used:

- Prebuilt Docker images: https://render.com/docs/deploying-an-image
- Docker on Render: https://render.com/docs/docker
- Web services and port binding: https://render.com/docs/web-services
- Render Postgres connection details: https://render.com/docs/databases

## 1. What Render Is Running

The deployed app is one Docker container running:

```text
java -jar /app/app.jar
```

The JAR already contains:

- Spring Boot backend
- Angular production build copied into `backend/src/main/resources/static`

Render provides:

- Public HTTPS URL
- Routing to the web service
- Managed Postgres database
- Logs and manual deploys

You do not need:

- Nginx
- Certbot
- Docker Compose
- EC2 security groups
- A separate Angular static site

## 2. Local Prerequisites

Install locally:

- Java 21
- Maven
- Node 20+ and npm
- Docker
- A Docker registry account, for example Docker Hub or GitHub Container Registry

The examples below use Docker Hub:

```text
docker.io/YOUR_DOCKERHUB_USERNAME/swe-quizzes:VERSION
```

Replace:

- `YOUR_DOCKERHUB_USERNAME`
- `VERSION`

Example version:

```text
v1
```

## 3. Build the Spring Boot JAR Locally

From the project root:

```bash
chmod +x build-dist.sh
./build-dist.sh
```

This script:

1. Runs `npm ci` in `frontend/`.
2. Runs `npm run build` in `frontend/`.
3. Copies the Angular dist into `backend/src/main/resources/static/`.
4. Builds the Spring Boot JAR.

Expected artifact:

```text
backend/target/swe-quizzes-0.0.1-SNAPSHOT.jar
```

Verify it exists:

```bash
ls -lh backend/target/swe-quizzes-0.0.1-SNAPSHOT.jar
```

## 4. Create a Render Dockerfile

Create a file named `Dockerfile.render` in the project root:

```dockerfile
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

RUN addgroup -S app && adduser -S app -G app

COPY backend/target/swe-quizzes-0.0.1-SNAPSHOT.jar /app/app.jar

RUN chown -R app:app /app
USER app

EXPOSE 10000

ENTRYPOINT ["sh", "-c", "exec java -Xms256m -Xmx768m -Dserver.port=${PORT:-10000} -jar /app/app.jar"]
```

Why this Dockerfile is Render-specific:

- Render web services expect the app to bind to a public HTTP port.
- Render's default web service port is `10000`.
- `-Dserver.port=${PORT:-10000}` lets Render override the port if needed.
- Spring Boot binds to `0.0.0.0` inside the container by default.

For the smallest paid Render instance, if memory is tight, reduce heap:

```text
-Xmx512m
```

## 5. Build the Docker Image

Render requires prebuilt Docker images to support `linux/amd64`.

From the project root:

```bash
docker buildx build \
  --platform linux/amd64 \
  -f Dockerfile.render \
  -t allan8tech/swe-quizzes:v1 \
  --load \
  .
```

Verify the image exists locally:

```bash
docker images | grep swe-quizzes
```

## 6. Test the Docker Image Locally

Start a local Postgres first. If you already use the repo's local Docker Compose database, run:

```bash
docker compose up -d postgres
```

Then run the image:

```bash
docker run --rm \
  -p 10000:10000 \
  -e PORT=10000 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/swequizzes \
  -e SPRING_DATASOURCE_USERNAME=swequizzes \
  -e SPRING_DATASOURCE_PASSWORD=swequizzes \
  YOUR_DOCKERHUB_USERNAME/swe-quizzes:v1
```

Open:

```text
http://localhost:10000
```

Check the public settings API:

```bash
curl http://localhost:10000/api/settings/public
```

If `host.docker.internal` does not work on your Linux Docker setup, use the Docker bridge IP or test directly on Render after pushing the image.

## 7. Push the Image to Docker Hub

Login:

```bash
docker login
```

Push:

```bash
docker push allan8tech/swe-quizzes:v1
```

The image URL for Render will be:

```text
docker.io/YOUR_DOCKERHUB_USERNAME/swe-quizzes:v1
```

You can use a public Docker Hub repository for the simplest setup.

If the image is private, create a Docker Hub access token and add it as a Render container registry credential when creating the service.

## 8. Create Render Postgres

In the Render dashboard:

1. Click **New**.
2. Choose **Postgres**.
3. Choose a name, for example `swe-quizzes-db`.
4. Choose the same region you will use for the web service.
5. Choose the lowest paid plan that fits your needs.
6. Create the database.

Do not use free Postgres for production. Render free Postgres databases expire after the free period and are not suitable for persistent production data.

After the database is created, open its dashboard and find the internal connection details.

You need:

- Internal host
- Port, usually `5432`
- Database name
- Username
- Password

Render also shows an internal URL like:

```text
postgresql://USER:PASSWORD@INTERNAL_HOST:5432/DATABASE
```

Spring Boot needs JDBC format, so convert it to:

```text
jdbc:postgresql://INTERNAL_HOST:5432/DATABASE
```

## 9. Create the Render Web Service from the Docker Image

In the Render dashboard:

1. Click **New**.
2. Choose **Web Service**.
3. Choose **Existing Image**.
4. Enter the image URL:

```text
docker.io/YOUR_DOCKERHUB_USERNAME/swe-quizzes:v1
```

5. If the image is private, add/select your Docker Hub registry credential.
6. Click **Connect** after Render verifies the image.
7. Name the service, for example `swe-quizzes`.
8. Choose the same region as the Render Postgres database.
9. Choose an instance type.
10. Set the health check path:

```text
/api/settings/public
```

11. Add the environment variables from the next section.
12. Click **Deploy Web Service**.

## 10. Configure Environment Variables

In the Render Web Service environment settings, add:

```env
PORT=10000
SPRING_DATASOURCE_URL=jdbc:postgresql://INTERNAL_HOST:5432/DATABASE
SPRING_DATASOURCE_USERNAME=USER
SPRING_DATASOURCE_PASSWORD=PASSWORD
SPRING_JPA_SHOW_SQL=false
```

Replace the database values with the internal Render Postgres values.

Example:

```env
PORT=10000
SPRING_DATASOURCE_URL=jdbc:postgresql://dpg-abc123-a:5432/swequizzes
SPRING_DATASOURCE_USERNAME=swequizzes
SPRING_DATASOURCE_PASSWORD=your-render-password
SPRING_JPA_SHOW_SQL=false
```

Do not use the external database URL from the web service. Use the internal database host/URL because it stays inside Render's private network and has lower latency.

## 11. First Deploy Verification

After the deploy finishes, Render gives the service a URL like:

```text
https://swe-quizzes.onrender.com
```

Open:

```text
https://swe-quizzes.onrender.com
```

Check the API:

```text
https://swe-quizzes.onrender.com/api/settings/public
```

Expected:

- Angular loads from `/`.
- Public quizzes work without login.
- `/api/settings/public` returns JSON.
- Register/login works.
- Admin settings work if an admin account exists.
- My quizzes and custom quiz creation work after login.

## 12. Manual Redeploy With a New Image

When you change code, repeat the local build:

```bash
./build-dist.sh
```

Build a new image tag:

```bash
docker buildx build \
  --platform linux/amd64 \
  -f Dockerfile.render \
  -t YOUR_DOCKERHUB_USERNAME/swe-quizzes:v2 \
  --load \
  .
```

Push it:

```bash
docker push YOUR_DOCKERHUB_USERNAME/swe-quizzes:v2
```

In Render:

1. Open the Web Service.
2. Go to **Settings**.
3. Update the image URL to:

```text
docker.io/YOUR_DOCKERHUB_USERNAME/swe-quizzes:v2
```

4. Click **Manual Deploy**.
5. Choose **Deploy latest reference**.

For simpler redeploys, you can keep using the same tag, for example `latest`, but versioned tags like `v1`, `v2`, `v3` make rollback clearer.

## 13. Database Migrations

The backend uses Flyway. On each app startup, Spring Boot runs pending migrations against Render Postgres.

Watch the Render logs during deploy:

```text
Flyway
Successfully applied
Started SweQuizzesApplication
```

If a migration fails, Render will keep the old healthy deploy if the new instance does not pass health checks.

## 14. Logs and Troubleshooting

View logs:

1. Open the Render Web Service.
2. Click **Logs**.

Common problem: app starts on the wrong port.

Fix:

- Confirm `PORT=10000`.
- Confirm the Dockerfile includes:

```text
-Dserver.port=${PORT:-10000}
```

Common problem: database connection fails.

Fix:

- Use the Render Postgres internal host.
- Keep the web service and Postgres in the same Render region.
- Confirm `SPRING_DATASOURCE_URL` starts with `jdbc:postgresql://`.
- Confirm username/password match Render's database credentials.

Common problem: image pull fails.

Fix:

- Confirm the image URL is correct.
- Confirm the image was pushed.
- If the image is private, confirm Render has a valid registry credential.
- Confirm the image supports `linux/amd64`.

Common problem: the container is killed for memory.

Fix:

- Reduce `-Xmx768m` to `-Xmx512m`.
- Upgrade the Render instance type.

## 15. Cost Notes

For predictable cost, use:

- One paid Render Web Service.
- One paid Render Postgres database.
- No extra background workers unless needed.
- No preview environments.
- No separate static frontend service.

The Spring Boot app already serves Angular, so deploying a separate Render Static Site is unnecessary for this project.

Check current prices before deploying:

```text
https://render.com/pricing
```

## 16. Final Checklist

- `./build-dist.sh` succeeds locally.
- `backend/target/swe-quizzes-0.0.1-SNAPSHOT.jar` exists.
- `Dockerfile.render` copies that JAR.
- Docker image is built with `--platform linux/amd64`.
- Docker image is pushed to a registry.
- Render Postgres exists in the same region as the web service.
- Render Web Service uses **Existing Image**.
- `PORT=10000` is set.
- `SPRING_DATASOURCE_URL` uses JDBC format and the internal Render database host.
- Health check path is `/api/settings/public`.
- App loads at the Render URL.
