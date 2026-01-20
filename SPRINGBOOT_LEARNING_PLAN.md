# Spring Boot Learning Plan - Complete Guide

## Overview
A structured 8-week learning path with hands-on projects, code examples, and practice exercises.

---

## 📋 Prerequisites
- Java 17+ installed
- Maven 3.6+
- Basic Java knowledge (OOP, Collections)
- Git basics

---

## 🎯 Learning Path

### **PHASE 1: Foundations (Week 1-2)**

#### Week 1: Spring Boot Basics

**Concepts to Learn:**
- Spring Boot overview and advantages
- Auto-configuration
- Embedded Tomcat server
- Application properties

**Project 1: Hello Spring Boot**
```
Location: /springboot-projects/project-1-hello-world/
```

**Tasks:**
1. Create basic Spring Boot app
2. Create REST endpoint `/hello`
3. Run application and test endpoint
4. Modify application properties

**Practice:**
- [ ] Change server port to 8081
- [ ] Add multiple endpoints (`/greet`, `/welcome`)
- [ ] Return JSON responses

---

#### Week 2: Dependency Injection & Annotations

**Concepts to Learn:**
- @SpringBootApplication
- @RestController
- @GetMapping, @PostMapping
- @Service, @Repository
- Dependency Injection (DI)

**Project 2: Todo API - Basic**
```
Location: /springboot-projects/project-2-todo-api/
```

**Implementation:**
```java
// TodoController.java
@RestController
@RequestMapping("/api/todos")
public class TodoController {
    
    @Autowired
    private TodoService todoService;
    
    @GetMapping
    public List<Todo> getAllTodos() {
        return todoService.getAllTodos();
    }
    
    @PostMapping
    public Todo createTodo(@RequestBody Todo todo) {
        return todoService.saveTodo(todo);
    }
    
    @GetMapping("/{id}")
    public Todo getTodoById(@PathVariable Long id) {
        return todoService.getTodoById(id);
    }
}

// TodoService.java
@Service
public class TodoService {
    private List<Todo> todos = new ArrayList<>();
    
    public List<Todo> getAllTodos() {
        return todos;
    }
    
    public Todo saveTodo(Todo todo) {
        todo.setId(System.currentTimeMillis());
        todos.add(todo);
        return todo;
    }
    
    public Todo getTodoById(Long id) {
        return todos.stream()
            .filter(t -> t.getId().equals(id))
            .findFirst()
            .orElse(null);
    }
}

// Todo.java
public class Todo {
    private Long id;
    private String title;
    private String description;
    private boolean completed;
    
    // Getters and Setters
}
```

**Practice:**
- [ ] Add `@PutMapping` to update todos
- [ ] Add `@DeleteMapping` to delete todos
- [ ] Add filtering by completion status

---

### **PHASE 2: Database Integration (Week 3-4)**

#### Week 3: JPA & Hibernate

**Concepts to Learn:**
- JPA annotations (@Entity, @Id, @Column)
- Hibernate basics
- Relationships (One-to-Many, Many-to-One)
- Repository pattern

**Project 3: Todo API - With Database**
```
Location: /springboot-projects/project-3-todo-database/
```

**Implementation:**
```java
// application.properties
spring.datasource.url=jdbc:h2:mem:tododb
spring.datasource.driverClassName=org.h2.Driver
spring.jpa.hibernate.ddl-auto=create-drop
spring.h2.console.enabled=true

// Todo.java (Entity)
@Entity
@Table(name = "todos")
public class Todo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String title;
    
    @Column(length = 500)
    private String description;
    
    @Column(name = "is_completed")
    private boolean completed;
    
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = new Date();
    }
    
    // Getters and Setters
}

// TodoRepository.java
@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {
    List<Todo> findByCompleted(boolean completed);
    List<Todo> findByTitleContainingIgnoreCase(String title);
}

// TodoService.java (Updated)
@Service
public class TodoService {
    @Autowired
    private TodoRepository todoRepository;
    
    public List<Todo> getAllTodos() {
        return todoRepository.findAll();
    }
    
    public Todo saveTodo(Todo todo) {
        return todoRepository.save(todo);
    }
    
    public Todo getTodoById(Long id) {
        return todoRepository.findById(id).orElse(null);
    }
    
    public void deleteTodo(Long id) {
        todoRepository.deleteById(id);
    }
    
    public List<Todo> getCompletedTodos() {
        return todoRepository.findByCompleted(true);
    }
    
    public List<Todo> searchTodos(String keyword) {
        return todoRepository.findByTitleContainingIgnoreCase(keyword);
    }
}
```

**Practice:**
- [ ] Query data by different criteria
- [ ] Add pagination
- [ ] Add sorting

---

#### Week 4: Relationships & Queries

**Concepts to Learn:**
- One-to-Many relationships
- Many-to-One relationships
- Custom queries
- Query methods

**Project 4: Todo with Categories**
```
Location: /springboot-projects/project-4-todo-categories/
```

**Implementation:**
```java
// Category.java
@Entity
@Table(name = "categories")
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true)
    private String name;
    
    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL)
    private List<Todo> todos = new ArrayList<>();
    
    // Getters and Setters
}

// Todo.java (Updated)
@Entity
@Table(name = "todos")
public class Todo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    private String description;
    private boolean completed;
    
    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;
    
    // Getters and Setters
}

// Custom Queries
@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {
    @Query("SELECT t FROM Todo t WHERE t.category.id = ?1 AND t.completed = false")
    List<Todo> findPendingByCategory(Long categoryId);
    
    @Query("SELECT COUNT(t) FROM Todo t WHERE t.category.id = ?1")
    long countByCategory(Long categoryId);
}
```

**Practice:**
- [ ] Create categories
- [ ] Assign todos to categories
- [ ] Query todos by category
- [ ] Delete category with cascading

---

### **PHASE 3: API Best Practices (Week 5-6)**

#### Week 5: Exception Handling & Validation

**Concepts to Learn:**
- @ExceptionHandler
- @ControllerAdvice
- Bean Validation (@Valid, @NotNull, etc.)
- Custom exceptions
- Response entity

**Project 5: Todo API - Production Ready**
```
Location: /springboot-projects/project-5-production-api/
```

**Implementation:**
```java
// Custom Exceptions
public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}

public class BadRequestException extends RuntimeException {
    public BadRequestException(String message) {
        super(message);
    }
}

// Global Exception Handler
@ControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<?> handleResourceNotFound(ResourceNotFoundException ex) {
        ErrorResponse errorResponse = new ErrorResponse(
            "NOT_FOUND",
            ex.getMessage(),
            System.currentTimeMillis()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }
    
    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<?> handleBadRequest(BadRequestException ex) {
        ErrorResponse errorResponse = new ErrorResponse(
            "BAD_REQUEST",
            ex.getMessage(),
            System.currentTimeMillis()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<?> handleValidationError(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(error ->
            errors.put(error.getField(), error.getDefaultMessage())
        );
        return new ResponseEntity<>(errors, HttpStatus.BAD_REQUEST);
    }
}

// DTO with Validation
public class CreateTodoRequest {
    @NotBlank(message = "Title cannot be blank")
    @Size(min = 3, max = 100, message = "Title must be between 3 and 100 characters")
    private String title;
    
    @Size(max = 500, message = "Description cannot exceed 500 characters")
    private String description;
    
    @NotNull(message = "Category ID cannot be null")
    private Long categoryId;
    
    // Getters and Setters
}

// Updated Controller
@RestController
@RequestMapping("/api/todos")
public class TodoController {
    
    @Autowired
    private TodoService todoService;
    
    @PostMapping
    public ResponseEntity<?> createTodo(@Valid @RequestBody CreateTodoRequest request) {
        try {
            Todo todo = todoService.createTodo(request);
            return new ResponseEntity<>(todo, HttpStatus.CREATED);
        } catch (ResourceNotFoundException e) {
            throw e;
        }
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<?> getTodoById(@PathVariable Long id) {
        Todo todo = todoService.getTodoById(id);
        if (todo == null) {
            throw new ResourceNotFoundException("Todo not found with id: " + id);
        }
        return ResponseEntity.ok(todo);
    }
}

// Error Response DTO
public class ErrorResponse {
    private String errorCode;
    private String message;
    private long timestamp;
    
    // Constructor and Getters
}
```

**Practice:**
- [ ] Add validation to all endpoints
- [ ] Test error scenarios
- [ ] Create standardized error responses

---

#### Week 6: Logging & Monitoring

**Concepts to Learn:**
- SLF4J logging
- Log levels
- Application monitoring
- Actuator endpoints

**Implementation:**
```java
// application.properties
logging.level.root=INFO
logging.level.com.example.demo=DEBUG
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} - %logger{36} - %msg%n

// Add dependency in pom.xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>

// Service with Logging
@Service
public class TodoService {
    private static final Logger logger = LoggerFactory.getLogger(TodoService.class);
    
    @Autowired
    private TodoRepository todoRepository;
    
    public Todo createTodo(CreateTodoRequest request) {
        logger.info("Creating new todo with title: {}", request.getTitle());
        
        Todo todo = new Todo();
        todo.setTitle(request.getTitle());
        todo.setDescription(request.getDescription());
        
        try {
            Todo savedTodo = todoRepository.save(todo);
            logger.info("Todo created successfully with id: {}", savedTodo.getId());
            return savedTodo;
        } catch (Exception e) {
            logger.error("Error creating todo", e);
            throw new BadRequestException("Failed to create todo");
        }
    }
    
    public List<Todo> getAllTodos() {
        logger.debug("Fetching all todos");
        List<Todo> todos = todoRepository.findAll();
        logger.debug("Found {} todos", todos.size());
        return todos;
    }
}
```

**Practice:**
- [ ] Add logging to all services
- [ ] Monitor application with `/actuator` endpoints
- [ ] Check logs for errors

---

### **PHASE 4: Advanced Topics (Week 7-8)**

#### Week 7: Security & Authentication

**Concepts to Learn:**
- Spring Security basics
- JWT tokens
- Password encoding
- Authorization

**Project 6: Todo API with Authentication**
```
Location: /springboot-projects/project-6-secure-api/
```

**Implementation:**
```java
// pom.xml - Add dependencies
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.11.5</version>
</dependency>

// User.java (Entity)
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true)
    private String username;
    
    private String password;
    private String email;
    
    @OneToMany(mappedBy = "user")
    private List<Todo> todos;
    
    // Getters and Setters
}

// Updated Todo.java
@Entity
public class Todo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    private String description;
    private boolean completed;
    
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    
    // Getters and Setters
}

// JWT Token Provider
@Component
public class JwtTokenProvider {
    @Value("${jwt.secret}")
    private String jwtSecret;
    
    @Value("${jwt.expiration}")
    private long jwtExpiration;
    
    public String generateToken(String username) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpiration);
        
        return Jwts.builder()
            .setSubject(username)
            .setIssuedAt(now)
            .setExpiration(expiryDate)
            .signWith(SignatureAlgorithm.HS512, jwtSecret)
            .compact();
    }
    
    public String getUsernameFromToken(String token) {
        return Jwts.parser()
            .setSigningKey(jwtSecret)
            .parseClaimsJws(token)
            .getBody()
            .getSubject();
    }
    
    public boolean validateToken(String token) {
        try {
            Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}

// Auth Controller
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private JwtTokenProvider tokenProvider;
    
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody SignUpRequest request) {
        User user = userService.createUser(request);
        return new ResponseEntity<>(user, HttpStatus.CREATED);
    }
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        User user = userService.authenticateUser(request.getUsername(), request.getPassword());
        String token = tokenProvider.generateToken(user.getUsername());
        return ResponseEntity.ok(new JwtResponse(token));
    }
}

// application.properties
jwt.secret=your-secret-key-here-make-it-very-long-and-secure
jwt.expiration=86400000
```

**Practice:**
- [ ] Register new users
- [ ] Login and get JWT token
- [ ] Secure endpoints with @Secured annotation
- [ ] Test authentication flow

---

#### Week 8: Testing & Deployment

**Concepts to Learn:**
- Unit testing (JUnit)
- Integration testing
- Mocking (@Mock, @InjectMocks)
- Test containers
- Building JAR and Docker

**Project 7: Complete Todo App with Tests**
```
Location: /springboot-projects/project-7-complete-app/
```

**Implementation:**
```java
// TodoControllerTest.java
@SpringBootTest
@AutoConfigureMockMvc
public class TodoControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @MockBean
    private TodoService todoService;
    
    @Test
    public void testGetAllTodos() throws Exception {
        List<Todo> todos = Arrays.asList(
            new Todo(1L, "Task 1", "", false),
            new Todo(2L, "Task 2", "", false)
        );
        
        when(todoService.getAllTodos()).thenReturn(todos);
        
        mockMvc.perform(get("/api/todos"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$", hasSize(2)))
            .andExpect(jsonPath("$[0].title", is("Task 1")));
    }
    
    @Test
    public void testCreateTodo() throws Exception {
        CreateTodoRequest request = new CreateTodoRequest();
        request.setTitle("New Task");
        request.setDescription("Task description");
        
        Todo savedTodo = new Todo(1L, "New Task", "Task description", false);
        when(todoService.createTodo(any())).thenReturn(savedTodo);
        
        mockMvc.perform(post("/api/todos")
            .contentType(MediaType.APPLICATION_JSON)
            .content(new ObjectMapper().writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.id", is(1)));
    }
    
    @Test
    public void testGetTodoNotFound() throws Exception {
        when(todoService.getTodoById(1L)).thenReturn(null);
        
        mockMvc.perform(get("/api/todos/1"))
            .andExpect(status().isNotFound());
    }
}

// TodoServiceTest.java
@SpringBootTest
public class TodoServiceTest {
    
    @MockBean
    private TodoRepository todoRepository;
    
    @InjectMocks
    private TodoService todoService;
    
    @Test
    public void testGetAllTodos() {
        List<Todo> mockTodos = Arrays.asList(
            new Todo(1L, "Task 1", "", false),
            new Todo(2L, "Task 2", "", false)
        );
        
        when(todoRepository.findAll()).thenReturn(mockTodos);
        
        List<Todo> result = todoService.getAllTodos();
        
        assertEquals(2, result.size());
        verify(todoRepository, times(1)).findAll();
    }
}

// Dockerfile
FROM openjdk:17-jdk-slim
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

// docker-compose.yml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://db:3306/tododb
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: password
    depends_on:
      - db
  
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: tododb
    ports:
      - "3306:3306"
```

**Practice:**
- [ ] Write unit tests for services
- [ ] Write integration tests for controllers
- [ ] Achieve 80%+ code coverage
- [ ] Build Docker image
- [ ] Run with Docker Compose

---

## 📚 Recommended Study Resources

### Official Documentation
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa)
- [Spring Security](https://spring.io/projects/spring-security)

### Practice Exercises

**Week 1-2:**
- [ ] Create 5 different REST endpoints
- [ ] Return different response types (String, JSON, Object)
- [ ] Test with curl/Postman

**Week 3-4:**
- [ ] Design database schema for Blog (Post, Comment, User)
- [ ] Implement One-to-Many relationship
- [ ] Write custom query methods

**Week 5-6:**
- [ ] Add validation to all DTOs
- [ ] Create comprehensive error handling
- [ ] Add logging to all layers

**Week 7-8:**
- [ ] Implement JWT authentication
- [ ] Write 20+ unit tests
- [ ] Containerize application

---

## 🚀 Build & Run Commands

```bash
# Build project
mvn clean install

# Run application
mvn spring-boot:run

# Run tests
mvn test

# Build JAR
mvn clean package

# Run JAR
java -jar target/demo-0.0.1-SNAPSHOT.jar

# Run with Docker
docker build -t todo-app .
docker run -p 8080:8080 todo-app
```

---

## 📊 Expected Outcomes

**By Week 4:**
- Build complete REST API with database
- Understand JPA relationships
- Query data effectively

**By Week 6:**
- Production-ready API with proper error handling
- Comprehensive logging
- Input validation

**By Week 8:**
- Secure API with authentication
- Full test coverage
- Containerized application

---

## 🎓 Next Steps After Week 8

1. **Microservices** - Break into multiple services
2. **Message Queues** - RabbitMQ/Kafka
3. **Caching** - Redis integration
4. **Cloud Deployment** - AWS/GCP/Azure
5. **Advanced Patterns** - CQRS, Event Sourcing

---

## 💡 Tips for Success

1. **Code daily** - Even 30 minutes is productive
2. **Follow DRY** - Don't repeat yourself
3. **Write tests first** - TDD approach
4. **Use Git** - Commit frequently
5. **Read documentation** - Official Spring docs are excellent
6. **Debug actively** - Use IDE debugger
7. **Practice, don't memorize** - Build projects
8. **Join community** - Stack Overflow, Reddit, forums

---

**Happy Learning! 🎯**
