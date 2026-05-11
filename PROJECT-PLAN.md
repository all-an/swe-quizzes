# PROJECT-PLAN.md — Software Engineering Quizzes (swe-quizzes)

A quiz platform covering AWS, Java, and Angular topics.

## Stack

- **Frontend:** Angular (CSR, served as static files)
- **Backend:** Spring Boot (REST API + static file serving)
- **Deployment:** Single JAR — no Node.js in production

## Project Structure

```
swe-quizzes/
  frontend/        ← Angular project (ng new)
  backend/         ← Spring Boot project (Maven/Gradle)
```

Angular builds into `frontend/dist/`, which gets copied into `backend/src/main/resources/static/`.

## Data Model

```
Question
  - id
  - text
  - category        (AWS | JAVA | ANGULAR)
  - answerTimeSecs  (time allowed to answer)
  - answers         List<Answer>

Answer
  - id
  - text
  - correct         (boolean)
  - question        (FK → Question)
```

## UI — Main Page

Three entry buttons, each starting a quiz filtered by category:

```
[ AWS ]   [ Java ]   [ Angular ]
```

## API Routing Convention

```
/api/**   → Spring Boot controllers
/**       → Angular (index.html fallback)
```

## Deep Link Fix

Spring Boot needs a catch-all controller to forward unknown routes to Angular's `index.html`, preventing 404s on direct URL access or page refresh:

```java
@Controller
public class SpaController {
    @RequestMapping(value = "/{path:[^\\.]*}")
    public String redirect() {
        return "forward:/index.html";
    }
}
```

## Build Workflow

Manual:
```bash
cd frontend && ng build --configuration production
cp -r frontend/dist/your-app/* backend/src/main/resources/static/
cd backend && ./mvnw spring-boot:run
```

Automated via `frontend-maven-plugin` in `pom.xml` — a single `mvn package` builds Angular and Spring Boot, producing one deployable `.jar`.

## Deployment

- **Platform:** Render.com
- **Method:** Docker (manual deploy, no CI/CD)
- **Artifact:** Single Docker image — builds Angular, compiles Spring Boot, runs the JAR

```dockerfile
# Stage 1 — build Angular
FROM node:20 AS frontend
WORKDIR /app/frontend
COPY frontend/ .
RUN npm ci && npm run build --configuration production

# Stage 2 — build Spring Boot
FROM maven:3.9-eclipse-temurin-21 AS backend
WORKDIR /app/backend
COPY backend/ .
COPY --from=frontend /app/frontend/dist ./src/main/resources/static
RUN mvn package -DskipTests

# Stage 3 — runtime
FROM eclipse-temurin:21-jre
COPY --from=backend /app/backend/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

Deploy: push image to Docker Hub (or Render's registry), point Render to it.

## Development

In development, the frontend and backend run independently:

- **Backend:** `cd backend && ./mvnw spring-boot:run` → `localhost:8080`
- **Frontend:** `cd frontend && npm start` → `localhost:4200`

`frontend/proxy.conf.json` proxies all `/api` calls from the Angular dev server to `localhost:8080`, so no CORS configuration is needed during development.

## Roadmap — v1

- [x] Scaffold Spring Boot project with JPA, PostgreSQL, Flyway
- [x] Create `Quiz`, `Question`, and `Answer` entities + repository layer
- [x] Seed initial questions for AWS, Java, and Angular
- [x] REST endpoints: list quizzes, get quiz by ID
- [x] Scaffold Angular project, configure routing
- [x] Main page with category buttons (AWS, Java, Angular)
- [x] Quiz page: display question, answers, countdown timer per question
- [x] Result screen: show score at end of quiz
- [x] Wire Angular to Spring Boot API via dev proxy
- [x] Unit tests (backend: service + controller; frontend: service + components)
- [x] JaCoCo coverage report
- [ ] Single JAR build via `frontend-maven-plugin`
- [ ] Docker multi-stage build
- [ ] Deploy to AWS
