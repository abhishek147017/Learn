# Setup Guide - Development Environment

## Overview
This setup script automates the installation of all development tools needed for Java, Go, and database development.

## Tools Installed

### Core Tools
- **Java 17** - Programming language
- **Maven** - Build tool for Java projects
- **Go 1.21** - Programming language
- **PostgreSQL** - Database server
- **Node.js & npm** - JavaScript runtime and package manager

### Container & DevOps
- **Docker** - Container platform
- **Docker Compose** - Multi-container orchestration

### Development Utilities
- **Git** - Version control
- **curl/wget** - Download tools
- **build-essential** - C/C++ compiler and tools
- **tmux** - Terminal multiplexer
- **htop** - System monitoring
- **tree** - Directory tree viewer
- **jq** - JSON processor

### Optional Installs
- **JetBrains IntelliJ IDEA Community Edition**
- **VS Code Extensions** (Java, Go, Python, Git)

## Prerequisites

- Ubuntu 24.04.3 LTS (or compatible)
- 4+ GB RAM recommended
- 10+ GB disk space
- Internet connection
- Sudo privileges

## Installation Steps

### 1. Download the Script
```bash
# The script is already in your repo at /workspaces/java/setup.sh
```

### 2. Make it Executable
```bash
chmod +x setup.sh
```

### 3. Run the Script
```bash
./setup.sh
```

**Note:** The script will prompt for:
- Git username and email (if not already configured)
- Whether to install optional tools (IntelliJ, VS Code extensions)

### 4. Apply Docker Group Changes
```bash
# Option 1: Start a new shell with the docker group
newgrp docker

# Option 2: Logout and login again to apply changes
logout
```

## What Gets Installed

### Step-by-Step Breakdown

| Step | Tool | Version | Purpose |
|------|------|---------|---------|
| 1 | System Update | - | Update package lists |
| 2 | Build Tools | Latest | gcc, make, curl, wget, git |
| 3 | Java | 17 | Programming language |
| 4 | Maven | Latest | Java build tool |
| 5 | Go | 1.21.0 | Programming language |
| 6 | PostgreSQL | Latest | Database server |
| 7 | Node.js | Latest | JavaScript runtime |
| 8 | Docker | Latest | Container platform |
| 9 | Docker Compose | Latest | Multi-container tool |
| 10 | Git Config | - | User setup (optional) |
| 11 | Utilities | Latest | tmux, tree, jq, etc. |
| 12 | IntelliJ | Latest | IDE (optional) |
| 13 | VS Code Extensions | Latest | IDE plugins (optional) |

## After Installation

### 1. Verify Installations
```bash
java -version
mvn -v
go version
psql --version
node -v
npm -v
docker --version
docker-compose --version
git --version
```

### 2. PostgreSQL Setup (if using locally)
```bash
# Create user
sudo -u postgres createuser yourusername

# Create database
sudo -u postgres createdb yourdbname

# Connect to PostgreSQL
psql -U yourusername -d yourdbname
```

### 3. Configure Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global core.editor "nano"  # or vim
```

### 4. Test Installations
```bash
# Test Java
java -version

# Test Maven
mvn -version

# Test Go
go version

# Test Docker
docker run hello-world

# Test PostgreSQL
psql --version

# Test Node.js
node --version
npm --version
```

## Common Commands After Setup

### Java/Spring Boot Development
```bash
# Create new project
mvn archetype:generate

# Build project
mvn clean install

# Run Spring Boot app
mvn spring-boot:run

# Run tests
mvn test
```

### Go Development
```bash
# Create new project
go mod init github.com/username/projectname

# Run program
go run main.go

# Build binary
go build -o myapp

# Run tests
go test ./...
```

### Docker Commands
```bash
# Build image
docker build -t myapp:1.0 .

# Run container
docker run -p 8080:8080 myapp:1.0

# List containers
docker ps -a

# Docker Compose up
docker-compose up -d

# Docker Compose down
docker-compose down
```

### PostgreSQL Commands
```bash
# Connect to database
psql -U username -d database_name

# List databases
\l

# List tables
\dt

# Describe table
\d table_name

# Exit psql
\q
```

### Git Commands
```bash
# Clone repository
git clone <url>

# Create branch
git checkout -b feature-name

# Stage changes
git add .

# Commit changes
git commit -m "Commit message"

# Push changes
git push origin branch-name

# View status
git status

# View log
git log --oneline
```

## Troubleshooting

### Docker Permission Denied
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Apply new group
newgrp docker

# Or logout and login again
```

### PostgreSQL Connection Failed
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql

# Start PostgreSQL
sudo systemctl start postgresql

# Enable on startup
sudo systemctl enable postgresql
```

### Go GOPATH Issues
```bash
# Check Go environment
go env

# Set GOPATH if needed
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```

### Maven Build Fails
```bash
# Clear cache
mvn clean

# Rebuild
mvn install

# Use offline mode
mvn -o clean install
```

### Java Version Conflicts
```bash
# Check installed versions
update-alternatives --list java

# Switch version
sudo update-alternatives --config java
```

## Uninstalling Tools

If you need to uninstall any tool:

```bash
# Java
sudo apt-get remove openjdk-17-jdk

# Maven
sudo apt-get remove maven

# Go (manual removal)
sudo rm -rf /usr/local/go
# Edit ~/.bashrc to remove Go paths

# PostgreSQL
sudo apt-get remove postgresql postgresql-contrib

# Node.js
sudo apt-get remove nodejs npm

# Docker
sudo apt-get remove docker-ce docker-ce-cli containerd.io

# Docker Compose
sudo rm /usr/local/bin/docker-compose
```

## System Requirements

### Minimum
- 2 CPU cores
- 4 GB RAM
- 10 GB disk space
- Ubuntu 20.04 LTS or later

### Recommended
- 4+ CPU cores
- 8+ GB RAM
- 20+ GB disk space
- Ubuntu 24.04 LTS

## Environment Variables

The script automatically adds these to `~/.bashrc`:

```bash
# Go paths
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
```

To apply immediately:
```bash
source ~/.bashrc
```

## Support

For issues with specific tools:

- **Java**: [Java Documentation](https://docs.oracle.com/en/java/)
- **Maven**: [Maven Documentation](https://maven.apache.org/)
- **Go**: [Go Documentation](https://go.dev/doc/)
- **PostgreSQL**: [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- **Docker**: [Docker Documentation](https://docs.docker.com/)

## Next Steps

1. ✅ Run `./setup.sh`
2. ✅ Verify all installations
3. ✅ Clone/create your first project
4. ✅ Start developing!

Happy coding! 🚀
