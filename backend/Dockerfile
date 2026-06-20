# Build the API-only Spring Boot jar, then run it on a slim JRE.
# Build context is the backend/ directory: docker build -t swe-quizzes-backend backend/
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -B dependency:go-offline
COPY src ./src
RUN mvn -B clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

RUN addgroup -S app && adduser -S app -G app
COPY --from=build /build/target/swe-quizzes-0.0.1-SNAPSHOT.jar /app/app.jar
RUN chown -R app:app /app
USER app

EXPOSE 8080
ENTRYPOINT ["sh", "-c", "exec java ${JAVA_OPTS} -jar /app/app.jar"]
