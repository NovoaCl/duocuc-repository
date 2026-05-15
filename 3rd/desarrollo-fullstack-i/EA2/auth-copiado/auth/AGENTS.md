# AGENTS.md

## Tech Stack
- Java 21 + Spring Boot 4.0.6 + Maven
- MySQL database (Flyway migrations in `auth/src/main/resources/db/migration`)
- JWT auth via `com.auth0:java-jwt:4.4.0`
- Lombok for boilerplate

## Build & Run
```bash
cd auth
./mvnw spring-boot:run
```
Default profile is `dev` (set in `application.properties`).

Single test:
```bash
./mvnw test -Dtest=AuthApplicationTests
```

## Key Config
- Server port: `8083`
- DB: `jdbc:mysql://localhost:3306/db_usuario` (user: `root`, pass: `system`)
- `spring.jpa.hibernate.ddl-auto=none` — schema is managed by Flyway, not Hibernate
- JWT secret: `SuperClaveSecretaParaJWT1234567890`, expiration: `3600000` (ms)

## API Entry Point
- `POST /api/v1/auth/login` — accepts `DtoAuthRequest` (email, password), returns `DtoAuthResponse` (token, user info)

## DB Migrations
Flyway is enabled but **no migration files exist yet** in `db/migration`. Run `mvn flyway:migrate` once the folder and SQL files are created.

## Note
- `SecurityConfig.java` is an empty interface placeholder — real security config may need to be implemented.
