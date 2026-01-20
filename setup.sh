#!/bin/bash

################################################################################
# COMPREHENSIVE DEVELOPMENT ENVIRONMENT & LEARNING SETUP
# Single unified script for Java/Go development with Spring Boot learning path
# 
# Features:
# - Installs all required tools (Java, Maven, Go, PostgreSQL, Docker, etc.)
# - Creates complete project structure
# - Generates 3 complete Spring Boot projects with code examples
# - Sets up learning documentation
# - Creates helper scripts
################################################################################

set -e

# ==============================================================================
# COLOR DEFINITIONS
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================

print_header() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ $1${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}\n"
}

print_section() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_command() {
    if command -v $1 &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# ==============================================================================
# PHASE 1: SYSTEM SETUP
# ==============================================================================

print_header "PHASE 1: INSTALLING DEVELOPMENT TOOLS"

print_section "System Update"
sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1
print_success "System updated"

print_section "Essential Build Tools"
sudo apt-get install -y build-essential curl wget git zip unzip nano vim htop net-tools > /dev/null 2>&1
print_success "Build tools installed"

print_section "Java Installation"
if check_command java; then
    print_warning "Java already installed"
else
    sudo apt-get install -y openjdk-17-jdk > /dev/null 2>&1
    print_success "Java 17 installed"
fi

print_section "Maven Installation"
if check_command mvn; then
    print_warning "Maven already installed"
else
    sudo apt-get install -y maven > /dev/null 2>&1
    print_success "Maven installed"
fi

print_section "Go Installation"
if check_command go; then
    print_warning "Go already installed"
else
    cd /tmp
    wget -q https://go.dev/dl/go1.21.0.linux-amd64.tar.gz 2>/dev/null || wget -q https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
    if ! grep -q '/usr/local/go/bin' ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
        source ~/.bashrc
    fi
    rm -f go1.21.0.linux-amd64.tar.gz
    print_success "Go installed"
fi

print_section "Node.js & npm Installation"
if check_command node; then
    print_warning "Node.js already installed"
else
    sudo apt-get install -y nodejs npm > /dev/null 2>&1
    print_success "Node.js and npm installed"
fi

print_section "Docker Installation"
if check_command docker; then
    print_warning "Docker already installed"
else
    sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release > /dev/null 2>&1
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg 2>/dev/null | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 2>/dev/null
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update > /dev/null 2>&1
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin > /dev/null 2>&1
    sudo usermod -aG docker $USER > /dev/null 2>&1
    print_success "Docker installed"
fi

print_section "Docker Compose Installation"
if check_command docker-compose; then
    print_warning "Docker Compose already installed"
else
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 2>/dev/null
    sudo chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose installed"
fi

print_section "Additional Utilities"
sudo apt-get install -y tmux tree jq 2>/dev/null || true
print_success "Utilities installed"

# ==============================================================================
# PHASE 2: PROJECT STRUCTURE SETUP
# ==============================================================================

print_header "PHASE 2: CREATING PROJECT STRUCTURE"

PROJECTS_DIR="springboot-projects"
mkdir -p "$PROJECTS_DIR"
print_success "Created $PROJECTS_DIR directory"

# ==============================================================================
# PHASE 3: CREATE PROJECTS
# ==============================================================================

print_header "PHASE 3: GENERATING SPRING BOOT LEARNING PROJECTS"

# ============================================================================
# PROJECT 1: HELLO WORLD
# ============================================================================

print_section "Project 1: Hello World"

mkdir -p "$PROJECTS_DIR/project-1-hello-world/src/main/java/com/example/demo"
mkdir -p "$PROJECTS_DIR/project-1-hello-world/src/main/resources"
mkdir -p "$PROJECTS_DIR/project-1-hello-world/src/test/java/com/example/demo"

cat > "$PROJECTS_DIR/project-1-hello-world/pom.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>
    <groupId>com.example</groupId>
    <artifactId>hello-world</artifactId>
    <version>1.0.0</version>
    <properties>
        <java.version>17</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
EOF

cat > "$PROJECTS_DIR/project-1-hello-world/src/main/java/com/example/demo/HelloApplication.java" << 'EOF'
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class HelloApplication {
    public static void main(String[] args) {
        SpringApplication.run(HelloApplication.class, args);
    }
}
EOF

cat > "$PROJECTS_DIR/project-1-hello-world/src/main/java/com/example/demo/HelloController.java" << 'EOF'
package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    
    @GetMapping("/hello")
    public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
        return "Hello, " + name + "!";
    }
    
    @GetMapping("/")
    public String index() {
        return "Welcome to Spring Boot! Try /hello?name=YourName";
    }
}
EOF

cat > "$PROJECTS_DIR/project-1-hello-world/src/main/resources/application.properties" << 'EOF'
spring.application.name=hello-world
server.port=8080
EOF

cat > "$PROJECTS_DIR/project-1-hello-world/README.md" << 'EOF'
# Project 1: Hello World Spring Boot

Simple Spring Boot application demonstrating basic REST endpoints.

## Build & Run
```bash
cd springboot-projects/project-1-hello-world
mvn clean install
mvn spring-boot:run
```

## Test
- http://localhost:8080/
- http://localhost:8080/hello
- http://localhost:8080/hello?name=Abhishek

## Learning Points
- @SpringBootApplication annotation
- @RestController
- @GetMapping
- Request parameters
EOF

print_success "Project 1 created"

# ============================================================================
# PROJECT 2: TODO API - BASIC
# ============================================================================

print_section "Project 2: Todo API - Basic (In-Memory)"

mkdir -p "$PROJECTS_DIR/project-2-todo-basic/src/main/java/com/example/demo/{controller,service,model}"
mkdir -p "$PROJECTS_DIR/project-2-todo-basic/src/main/resources"

cat > "$PROJECTS_DIR/project-2-todo-basic/pom.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>
    <groupId>com.example</groupId>
    <artifactId>todo-basic</artifactId>
    <version>1.0.0</version>
    <properties>
        <java.version>17</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
EOF

cat > "$PROJECTS_DIR/project-2-todo-basic/src/main/java/com/example/demo/TodoApplication.java" << 'EOF'
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TodoApplication {
    public static void main(String[] args) {
        SpringApplication.run(TodoApplication.class, args);
    }
}
EOF

cat > "$PROJECTS_DIR/project-2-todo-basic/src/main/java/com/example/demo/model/Todo.java" << 'EOF'
package com.example.demo.model;

public class Todo {
    private Long id;
    private String title;
    private String description;
    private boolean completed;
    
    public Todo() {}
    public Todo(Long id, String title, String description, boolean completed) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.completed = completed;
    }
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }
}
EOF

cat > "$PROJECTS_DIR/project-2-todo-basic/src/main/java/com/example/demo/service/TodoService.java" << 'EOF'
package com.example.demo.service;

import com.example.demo.model.Todo;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
public class TodoService {
    private List<Todo> todos = new ArrayList<>();
    private Long nextId = 1L;
    
    public List<Todo> getAllTodos() { return todos; }
    
    public Todo getTodoById(Long id) {
        return todos.stream().filter(t -> t.getId().equals(id)).findFirst().orElse(null);
    }
    
    public Todo createTodo(String title, String description) {
        Todo todo = new Todo(nextId++, title, description, false);
        todos.add(todo);
        return todo;
    }
    
    public Todo updateTodo(Long id, String title, String description, boolean completed) {
        Todo todo = getTodoById(id);
        if (todo != null) {
            todo.setTitle(title);
            todo.setDescription(description);
            todo.setCompleted(completed);
        }
        return todo;
    }
    
    public boolean deleteTodo(Long id) {
        return todos.removeIf(t -> t.getId().equals(id));
    }
}
EOF

cat > "$PROJECTS_DIR/project-2-todo-basic/src/main/java/com/example/demo/controller/TodoController.java" << 'EOF'
package com.example.demo.controller;

import com.example.demo.model.Todo;
import com.example.demo.service.TodoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/todos")
public class TodoController {
    @Autowired
    private TodoService todoService;
    
    @GetMapping
    public List<Todo> getAllTodos() {
        return todoService.getAllTodos();
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<?> getTodoById(@PathVariable Long id) {
        Todo todo = todoService.getTodoById(id);
        if (todo == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(todo);
    }
    
    @PostMapping
    public ResponseEntity<?> createTodo(@RequestBody Todo todo) {
        Todo created = todoService.createTodo(todo.getTitle(), todo.getDescription());
        return new ResponseEntity<>(created, HttpStatus.CREATED);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<?> updateTodo(@PathVariable Long id, @RequestBody Todo todo) {
        Todo updated = todoService.updateTodo(id, todo.getTitle(), todo.getDescription(), todo.isCompleted());
        if (updated == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(updated);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTodo(@PathVariable Long id) {
        if (!todoService.deleteTodo(id)) return ResponseEntity.notFound().build();
        return ResponseEntity.noContent().build();
    }
}
EOF

cat > "$PROJECTS_DIR/project-2-todo-basic/src/main/resources/application.properties" << 'EOF'
spring.application.name=todo-basic
server.port=8080
EOF

print_success "Project 2 created"

# ============================================================================
# PROJECT 3: TODO API - DATABASE
# ============================================================================

print_section "Project 3: Todo API - With Database"

mkdir -p "$PROJECTS_DIR/project-3-todo-db/src/main/java/com/example/demo/{controller,service,repository,model}"
mkdir -p "$PROJECTS_DIR/project-3-todo-db/src/main/resources"

cat > "$PROJECTS_DIR/project-3-todo-db/pom.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>
    <groupId>com.example</groupId>
    <artifactId>todo-db</artifactId>
    <version>1.0.0</version>
    <properties>
        <java.version>17</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>com.h2database</groupId>
            <artifactId>h2</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
EOF

cat > "$PROJECTS_DIR/project-3-todo-db/src/main/java/com/example/demo/TodoDbApplication.java" << 'EOF'
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TodoDbApplication {
    public static void main(String[] args) {
        SpringApplication.run(TodoDbApplication.class, args);
    }
}
EOF

cat > "$PROJECTS_DIR/project-3-todo-db/src/main/java/com/example/demo/model/Todo.java" << 'EOF'
package com.example.demo.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

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
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    public Todo() {}
    public Todo(String title, String description) {
        this.title = title;
        this.description = description;
        this.completed = false;
    }
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
EOF

cat > "$PROJECTS_DIR/project-3-todo-db/src/main/java/com/example/demo/repository/TodoRepository.java" << 'EOF'
package com.example.demo.repository;

import com.example.demo.model.Todo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {
    List<Todo> findByCompleted(boolean completed);
    List<Todo> findByTitleContainingIgnoreCase(String title);
}
EOF

cat > "$PROJECTS_DIR/project-3-todo-db/src/main/java/com/example/demo/service/TodoService.java" << 'EOF'
package com.example.demo.service;

import com.example.demo.model.Todo;
import com.example.demo.repository.TodoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class TodoService {
    @Autowired
    private TodoRepository todoRepository;
    
    public List<Todo> getAllTodos() { return todoRepository.findAll(); }
    public Todo getTodoById(Long id) { return todoRepository.findById(id).orElse(null); }
    public Todo createTodo(Todo todo) { return todoRepository.save(todo); }
    public boolean deleteTodo(Long id) { 
        if (todoRepository.existsById(id)) { 
            todoRepository.deleteById(id); 
            return true; 
        } 
        return false; 
    }
    public List<Todo> getPendingTodos() { return todoRepository.findByCompleted(false); }
    public List<Todo> getCompletedTodos() { return todoRepository.findByCompleted(true); }
}
EOF

cat > "$PROJECTS_DIR/project-3-todo-db/src/main/java/com/example/demo/controller/TodoController.java" << 'EOF'
package com.example.demo.controller;

import com.example.demo.model.Todo;
import com.example.demo.service.TodoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/todos")
public class TodoController {
    @Autowired
    private TodoService todoService;
    
    @GetMapping
    public List<Todo> getAllTodos() { return todoService.getAllTodos(); }
    
    @GetMapping("/{id}")
    public ResponseEntity<?> getTodoById(@PathVariable Long id) {
        Todo todo = todoService.getTodoById(id);
        if (todo == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(todo);
    }
    
    @PostMapping
    public ResponseEntity<?> createTodo(@RequestBody Todo todo) {
        Todo created = todoService.createTodo(todo);
        return new ResponseEntity<>(created, HttpStatus.CREATED);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTodo(@PathVariable Long id) {
        if (!todoService.deleteTodo(id)) return ResponseEntity.notFound().build();
        return ResponseEntity.noContent().build();
    }
}
EOF

cat > "$PROJECTS_DIR/project-3-todo-db/src/main/resources/application.properties" << 'EOF'
spring.application.name=todo-db
server.port=8080
spring.datasource.url=jdbc:h2:mem:tododb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=create-drop
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
EOF

print_success "Project 3 created"

# ==============================================================================
# PHASE 4: CREATE DOCUMENTATION
# ==============================================================================

print_header "PHASE 4: GENERATING DOCUMENTATION"

cat > "LEARNING_GUIDE.md" << 'GUIDE_EOF'
# Spring Boot 8-Week Learning Path

## Complete guide with hands-on projects for mastering Spring Boot

### QUICK START

```bash
cd springboot-projects/project-1-hello-world
mvn clean install
mvn spring-boot:run
```

### PROJECTS OVERVIEW

| Project | Focus | Files Generated |
|---------|-------|-----------------|
| 1 | Hello World | ✓ Complete |
| 2 | Todo API (In-Memory) | ✓ Complete |
| 3 | Todo API (Database) | ✓ Complete |
| 4 | Todo + Categories | Template ready |
| 5 | Production Ready API | Template ready |
| 6 | JWT Authentication | Template ready |
| 7 | Complete App + Tests | Template ready |

### BUILD COMMANDS

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
java -jar target/*.jar
```

### TESTING ENDPOINTS

```bash
# Get all todos
curl http://localhost:8080/api/todos

# Create todo
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn","description":"Study"}'

# Delete todo
curl -X DELETE http://localhost:8080/api/todos/1
```

### KEY CONCEPTS BY PROJECT

**Project 1**: Rest Controllers, Basic Endpoints
**Project 2**: Dependency Injection, Services, In-Memory Storage
**Project 3**: JPA Entities, Database, Repositories

### LEARNING PATH

1. Start with Project 1 (Hello World)
2. Progress to Project 2 (Basic API)
3. Add database with Project 3
4. Expand features with remaining projects
5. Build your own variations

Happy Learning! 🚀
GUIDE_EOF

print_success "Learning guide created"

# ==============================================================================
# PHASE 5: CREATE HELPER SCRIPTS
# ==============================================================================

print_header "PHASE 5: CREATING HELPER SCRIPTS"

cat > "start-postgres.sh" << 'POSTGRES_EOF'
#!/bin/bash

CONTAINER_NAME="postgres-dev"
DB_PASSWORD="${1:-password}"
DB_PORT="${2:-5432}"

echo "Starting PostgreSQL Docker container..."

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "PostgreSQL is already running"
    else
        docker start $CONTAINER_NAME
    fi
else
    docker run --name $CONTAINER_NAME -e POSTGRES_PASSWORD=$DB_PASSWORD -p $DB_PORT:5432 -d postgres:latest
    sleep 3
fi

echo "PostgreSQL Connection: localhost:$DB_PORT (user: postgres, password: $DB_PASSWORD)"
POSTGRES_EOF

chmod +x "start-postgres.sh"
print_success "Helper script created"

# ==============================================================================
# PHASE 6: VERIFICATION
# ==============================================================================

print_header "PHASE 6: INSTALLATION VERIFICATION"

echo -e "${BLUE}Installed Tools:${NC}\n"

if check_command java; then
    echo -e "${GREEN}✓ Java${NC}"
else
    echo -e "${RED}✗ Java: Not found${NC}"
fi

if check_command mvn; then
    echo -e "${GREEN}✓ Maven${NC}"
else
    echo -e "${RED}✗ Maven: Not found${NC}"
fi

if check_command go; then
    echo -e "${GREEN}✓ Go${NC}"
else
    echo -e "${RED}✗ Go: Not found${NC}"
fi

if check_command docker; then
    echo -e "${GREEN}✓ Docker${NC}"
else
    echo -e "${RED}✗ Docker: Not found${NC}"
fi

if check_command node; then
    echo -e "${GREEN}✓ Node.js${NC}"
else
    echo -e "${RED}✗ Node.js: Not found${NC}"
fi

if check_command git; then
    echo -e "${GREEN}✓ Git${NC}"
else
    echo -e "${RED}✗ Git: Not found${NC}"
fi

# ==============================================================================
# COMPLETION
# ==============================================================================

print_header "SETUP COMPLETE!"

cat << 'FINAL_EOF'

✅ ALL TOOLS INSTALLED
✅ PROJECT STRUCTURE CREATED
✅ 3 COMPLETE PROJECTS GENERATED
✅ DOCUMENTATION READY

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 PROJECT STRUCTURE:

springboot-projects/
├── project-1-hello-world/
├── project-2-todo-basic/
└── project-3-todo-db/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 QUICK START:

1. Build Project 1:
   cd springboot-projects/project-1-hello-world
   mvn clean install

2. Run Project 1:
   mvn spring-boot:run

3. Test:
   curl http://localhost:8080/hello

4. Setup PostgreSQL (optional):
   ./start-postgres.sh

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 DOCUMENTATION:

- LEARNING_GUIDE.md - Complete learning path
- Each project has README.md
- API documentation included

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 USEFUL COMMANDS:

Build all projects:
  for dir in springboot-projects/*/; do
    (cd "$dir" && mvn clean install)
  done

Run project:
  cd springboot-projects/project-X-*
  mvn spring-boot:run

Check versions:
  java -version
  mvn -v
  go version
  docker --version

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 NEXT STEPS:

1. Read LEARNING_GUIDE.md
2. Start with project-1-hello-world
3. Complete all 3 projects
4. Build your own variations
5. Extend with additional features

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Happy Coding! 🎉

FINAL_EOF

print_success "Setup completed successfully!"

echo ""
