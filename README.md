# Software Engineering Quizzes (swe-quizzes)

A full-stack quiz platform covering AWS, Java, and Angular topics. Built with Spring Boot (backend) and Angular (frontend), deployed as a single Docker container.

## Stack

- **Backend:** Spring Boot 3, Spring Data JPA, Flyway, PostgreSQL
- **Frontend:** Angular 21
- **Deployment:** Docker → Render.com

## Prerequisites

- Java 21
- Node 20+ / npm
- Docker

---

## Running locally

### 1. Start PostgreSQL

```bash
docker compose up -d
```

### 2. Run the backend

```bash
cd backend
./mvnw spring-boot:run
```

API available at `http://localhost:8080/api/quizzes`

### 3. Run the frontend (dev server with API proxy)

```bash
cd frontend
npm install
npm start
```

App available at `http://localhost:4200`. All `/api` requests are proxied to the backend — no CORS setup needed in development.

---

## Running tests

### Backend

```bash
cd backend
./mvn test
```

### Backend — generate coverage report (JaCoCo)

```bash
cd backend
./mvn verify
```

Report is generated at `backend/target/site/jacoco/index.html`.

### Frontend

```bash
cd frontend
npm test
```

---

## Building for production

```bash
docker build -t swe-quizzes .
docker run -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://<host>:5432/swequizzes \
  -e SPRING_DATASOURCE_USERNAME=<user> \
  -e SPRING_DATASOURCE_PASSWORD=<password> \
  swe-quizzes
```

---

## Database migrations

Flyway runs automatically on startup. Migration files live in `backend/src/main/resources/db/migration/`:

| File | Description |
|------|-------------|
| `V1__create_tables.sql` | Creates `quiz`, `question`, `answer` tables |
| `V2__seed_data.sql` | Seeds 3 quizzes with questions and answers |

---

## API

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/quizzes` | List all quizzes |
| GET | `/api/quizzes/{id}` | Get a quiz with questions and answers |
