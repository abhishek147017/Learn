
# Orderly

Orderly is a Spring Boot backend project built to learn and demonstrate **real-world backend development** using Java and Spring Boot, following **clean architecture** and **interview-grade best practices**.

This project evolves from a **monolith** to **microservices** step by step.

---

## Tech Stack

- Java 17
- Spring Boot
- Maven
- Spring Web
- Spring Data JPA
- H2 Database (Phase 1)
- MySQL/PostgreSQL (Later)
- Spring Boot DevTools
- IntelliJ IDEA

---

## Project Goals

- Learn Spring Boot with hands-on development
- Understand layered architecture
- Follow production-level coding practices
- Be interview-ready for backend roles
- Gradually move to microservices

---

## Architecture Overview

Layered architecture is strictly followed:

```

Controller → Service → Repository → Database

```

### Responsibilities

- **Controller**  
  Handles HTTP requests and responses only.

- **Service**  
  Contains business logic and transactions.

- **Repository**  
  Handles database access using JPA.

- **Entity**  
  Represents database tables.

- **DTO**  
  Used for request and response payloads.

---

## Package Structure

```

com.orderly.orderly
├── OrderlyApplication.java
├── controller
├── service
│   └── impl
├── repository
├── entity
├── dto
├── exception
├── config
└── util

````

---

## Coding Rules (Strict)

- No business logic in controllers
- No database access outside repositories
- Controllers talk only to service interfaces
- Entities are NOT exposed directly
- DTOs are used for API communication
- Proper HTTP status codes must be returned
- No `System.out.println`
- Use SLF4J logging only

---

## Current Phase: Project 1 (Core Monolith)

### Implemented / Planned Features

#### Health Check
- `GET /health`

#### User Management
- Create user
- Get user
- Update user
- Delete user

#### Order Management
- Create order
- Get order
- List orders by user

---

## Database

### Phase 1
- H2 in-memory database
- Used for fast development and learning

### Future
- MySQL / PostgreSQL
- Database per service (microservices phase)

---

## Configuration

- Configuration handled via `application.properties`
- No hard-coded values
- Profiles (`dev`, `prod`) added later

---

## Exception Handling

- Centralized exception handling using `@ControllerAdvice`
- Custom exceptions for business errors
- Standard HTTP error responses:
  - 400 – Bad Request
  - 404 – Not Found
  - 500 – Internal Server Error

---

## Logging

- SLF4J logging
- Logs at:
  - Controller entry
  - Service decision points
  - Exception handling

---

## Development Setup

### Prerequisites
- Java 17 installed
- IntelliJ IDEA
- Maven (or bundled with IntelliJ)

### Run Application
```bash
./mvnw spring-boot:run
````

App runs on:

```
http://localhost:8080
```

---

## Hot Reload & Debugging

* Spring Boot DevTools enabled
* IntelliJ Debugger used
* Application auto-restarts on code changes

---

## Definition of Done

The project is considered **DONE** when:

* Application starts without errors
* APIs work correctly via Postman
* Code follows defined structure
* No architectural violations
* All layers can be explained clearly

---

## Roadmap

1. Core Monolith (current)
2. Production-ready Monolith

    * JWT Security
    * Redis Cache
    * Transactions
3. Microservices Architecture

    * User Service
    * Order Service
    * Auth Service

---

## Author

Built as a learning and interview-preparation project.

```

---

### Next step
Create `/health` API **or** paste this file into `README.md` and confirm.

Say **NEXT STEP** when ready.
```
