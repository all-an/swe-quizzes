# Backend

Spring Boot API for the Software Engineering Quizzes app.

## Prerequisites

- Java 21 or newer
- Maven
- Docker, if you want to run PostgreSQL locally with Docker Compose

## Start PostgreSQL

From the repository root:

```bash
docker compose up -d postgres
```

The default backend configuration expects:

```text
jdbc:postgresql://localhost:5432/swequizzes
username: swequizzes
password: swequizzes
```

## Run The Backend

From this `backend` directory:

```bash
mvn spring-boot:run
```

The API starts on:

```text
http://localhost:8080
```

Useful endpoints:

```text
GET http://localhost:8080/api/categories
GET http://localhost:8080/api/quizzes
GET http://localhost:8080/api/quizzes?category=java
GET http://localhost:8080/api/quizzes/{id}
GET http://localhost:8080/api/questions/system?category=java
```

Public system quizzes remain available without an account. Authentication is required for custom quiz creation, `My Quizzes`, and admin endpoints.

Flyway migrations run automatically when the app starts.

## Auth And Accounts

The first registered account becomes `ADMIN`; later accounts become `USER`.

```bash
curl -X POST http://localhost:8080/api/accounts/register \
  -H 'Content-Type: application/json' \
  -d '{"name":"Admin","email":"admin@example.com","password":"secret123"}'
```

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"admin@example.com","password":"secret123"}'
```

Authenticated requests use:

```text
Authorization: Bearer <token>
```

## Custom Quizzes

Create a quiz for the logged-in account:

```bash
curl -X POST http://localhost:8080/api/quizzes \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "title": "CompletableFuture Practice",
    "description": "Async Java questions",
    "categorySlug": "java",
    "timeSeconds": 300,
    "systemQuestionIds": [],
    "questions": [
      {
        "text": "What does thenApply return?",
        "codeSnippet": "future.thenApply(value -> value.toUpperCase())",
        "codeLanguage": "java",
        "timeSeconds": 30,
        "answers": [
          { "description": "A transformed CompletableFuture", "correct": true },
          { "description": "A blocked thread", "correct": false }
        ]
      }
    ]
  }'
```

List quizzes owned by the logged-in account:

```text
GET /api/quizzes/my
```

Update a quiz owned by the logged-in account:

```text
PUT /api/quizzes/{id}
```

The update body has the same shape as `POST /api/quizzes`. Public system quizzes cannot be edited.

## Admin Settings And Logs

Admin-only endpoints:

```text
GET /api/admin/settings
PUT /api/admin/settings
GET /api/admin/access-logs
GET /api/admin/session-logs
```

Settings:

```json
{
  "disableLogin": false,
  "disableRegister": false
}
```

`disableLogin` blocks non-admin login while still allowing admin login. `disableRegister` blocks new account registration.

The frontend calls `POST /api/access-log` once per browser session. Login/register attempts are recorded in `session_log` with IP address, country from trusted headers when available, and user agent.

## Run Tests

From this `backend` directory:

```bash
mvn test
```

## Generate HTML Coverage Report

JaCoCo generates the HTML coverage report during the Maven `verify` phase:

```bash
mvn verify
```

Open the generated report at:

```text
target/site/jacoco/index.html
```

## Common Cleanup

Stop the process using backend port `8080`:

```bash
kill $(lsof -ti tcp:8080)
```

Stop the local PostgreSQL container:

```bash
docker compose down
```

Stop PostgreSQL and remove its local volume:

```bash
docker compose down -v
```
