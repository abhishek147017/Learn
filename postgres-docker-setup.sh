#!/bin/bash

# ============================================================================
# Docker PostgreSQL Setup Helper Script
# Useful for Codespaces and cloud environments
# ============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# ============================================================================
# Main Script
# ============================================================================

print_header "PostgreSQL Docker Setup"

# Get parameters with defaults
DB_PASSWORD="${1:-password}"
DB_PORT="${2:-5432}"
CONTAINER_NAME="postgres"

print_info "Configuration:"
echo "  Container: $CONTAINER_NAME"
echo "  Port: $DB_PORT"
echo "  Password: ••••••••"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running or not installed"
    exit 1
fi

print_success "Docker is running"

# Check if container already exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    print_info "Container '$CONTAINER_NAME' already exists"
    
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_success "Container is already running"
        
        echo -e "\n${BLUE}Connection Details:${NC}"
        echo "  Host: localhost"
        echo "  Port: $DB_PORT"
        echo "  Username: postgres"
        echo "  Password: $DB_PASSWORD"
        echo "  Default Database: postgres"
        
        exit 0
    else
        echo -e "\n${YELLOW}Container exists but is not running.${NC}"
        read -p "Start the existing container? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker start $CONTAINER_NAME
            print_success "Container started"
        else
            exit 0
        fi
    fi
else
    print_info "Creating new PostgreSQL container..."
    
    docker run \
        --name $CONTAINER_NAME \
        -e POSTGRES_PASSWORD=$DB_PASSWORD \
        -e POSTGRES_USER=postgres \
        -e POSTGRES_DB=postgres \
        -p $DB_PORT:5432 \
        -d \
        postgres:latest
    
    print_success "PostgreSQL container created and started"
    
    # Wait for PostgreSQL to be ready
    print_info "Waiting for PostgreSQL to be ready..."
    sleep 3
    
    for i in {1..30}; do
        if docker exec $CONTAINER_NAME pg_isready -U postgres > /dev/null 2>&1; then
            print_success "PostgreSQL is ready!"
            break
        fi
        if [ $i -eq 30 ]; then
            print_error "PostgreSQL failed to start within timeout"
            exit 1
        fi
        sleep 1
    done
fi

# ============================================================================
# Connection Information
# ============================================================================

print_header "PostgreSQL Ready!"

cat << EOF

✓ PostgreSQL is running in Docker

📋 CONNECTION DETAILS:

Host:     localhost
Port:     $DB_PORT
User:     postgres
Password: $DB_PASSWORD
Database: postgres

🔗 CONNECTION STRINGS:

psql (command line):
  psql -h localhost -U postgres -d postgres

JDBC (Java/Spring Boot):
  jdbc:postgresql://localhost:$DB_PORT/postgres

Connection URL (Node.js/etc):
  postgresql://postgres:$DB_PASSWORD@localhost:$DB_PORT/postgres

🐘 USEFUL COMMANDS:

Create database:
  docker exec $CONTAINER_NAME createdb -U postgres mydb

Create user:
  docker exec $CONTAINER_NAME createuser -U postgres myuser

Connect to database:
  docker exec -it $CONTAINER_NAME psql -U postgres -d postgres

View logs:
  docker logs $CONTAINER_NAME

Stop container:
  docker stop $CONTAINER_NAME

Start container:
  docker start $CONTAINER_NAME

Remove container (WARNING - deletes data):
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME

💾 DATA PERSISTENCE:

To persist data across container restarts, add volume:
  docker run --name postgres \\
    -e POSTGRES_PASSWORD=$DB_PASSWORD \\
    -v postgres_data:/var/lib/postgresql/data \\
    -p $DB_PORT:5432 \\
    -d postgres

EOF

print_success "Setup complete!"
