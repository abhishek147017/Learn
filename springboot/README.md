# Spring Boot Demo Application

A simple Spring Boot application for learning and development.

## Prerequisites

- Java 17 or higher
- Maven 3.6.0 or higher
- Git

## Project Structure

```
springboot/
├── src/
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── DemoApplication.java
│   │   │   └── controller/
│   │   │       └── HelloController.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/com/example/demo/
│           └── DemoApplicationTests.java
├── pom.xml
└── README.md
```

## Build Instructions

### Build the Project
```bash
mvn clean install
```

### Run the Application
```bash
mvn spring-boot:run
```

Or after building:
```bash
java -jar target/demo-0.0.1-SNAPSHOT.jar
```

## API Endpoints

- **Health Check**: `GET http://localhost:8080/api/health`
- **Hello Endpoint**: `GET http://localhost:8080/hello?name=YourName`

## Database

This application uses H2 in-memory database.

- **H2 Console**: `http://localhost:8080/h2-console`
- **URL**: `jdbc:h2:mem:testdb`
- **Username**: `sa`
- **Password**: (empty)

## Testing

Run tests with:
```bash
mvn test
```

## Dependencies

- Spring Boot 3.2.0
- Spring Web
- Spring Data JPA
- H2 Database
- Lombok
- JUnit 5

## Development

To make code changes and test:

1. Edit files in `src/main/`
2. Run `mvn clean install` to rebuild
3. Run `mvn spring-boot:run` to start the application

## Troubleshooting

If port 8080 is already in use, modify `application.properties`:
```properties
server.port=8081
```

## License

This is a demo project for educational purposes.
