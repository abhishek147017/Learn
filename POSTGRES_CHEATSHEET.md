# PostgreSQL Cheat Sheet

## Quick Reference for Common PostgreSQL Commands

### CONNECTION & ACCESS

```bash
# Connect to PostgreSQL with user
psql -U username -d database_name

# Connect to specific host and port
psql -h localhost -U postgres -p 5432

# Connect with password prompt
psql -U username -d database_name -W

# Connect to default database
psql -U postgres

# Exit psql
\q
```

---

## BASIC COMMANDS IN PSQL

### Meta Commands (Start with \)

```sql
-- List all databases
\l
\list

-- Connect to database
\c database_name

-- List all schemas
\dn

-- List all tables in current database
\dt

-- List all views
\dv

-- List all sequences
\ds

-- Describe table structure
\d table_name
\d+ table_name (with more details)

-- List all users/roles
\du
\dg

-- List all functions
\df

-- Get command help
\h
\h SELECT

-- Show query execution time
\timing

-- Execute previous command
\g

-- Show command history
\s

-- Clear screen
\clear
\c (also clears)

-- Toggle expanded display (vertical)
\x

-- Set output format to aligned
\a

-- Edit last query in editor
\e

-- Save query results to file
\o filename

-- Execute SQL from file
\i filename

-- Show all settings
\!

-- Quit psql
\q
```

---

## DATABASE OPERATIONS

### Create Database

```sql
-- Create database
CREATE DATABASE mydb;

-- Create database with specific owner
CREATE DATABASE mydb OWNER username;

-- Create database with encoding
CREATE DATABASE mydb ENCODING 'UTF8';

-- Create database with template
CREATE DATABASE mydb TEMPLATE template0;

-- Create if not exists
CREATE DATABASE IF NOT EXISTS mydb;
```

### Alter Database

```sql
-- Rename database
ALTER DATABASE old_name RENAME TO new_name;

-- Change owner
ALTER DATABASE mydb OWNER TO new_owner;

-- Set configuration
ALTER DATABASE mydb SET work_mem = '256MB';
```

### Drop Database

```sql
-- Drop database
DROP DATABASE mydb;

-- Drop if exists
DROP DATABASE IF EXISTS mydb;

-- Force drop (disconnect users first)
DROP DATABASE mydb WITH (FORCE);
```

### List Databases

```sql
SELECT datname FROM pg_database WHERE datistemplate = false;
```

---

## TABLE OPERATIONS

### Create Table

```sql
-- Basic table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- With constraints
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- If not exists
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

-- Temporary table
CREATE TEMP TABLE temp_users AS SELECT * FROM users;
```

### Alter Table

```sql
-- Add column
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Drop column
ALTER TABLE users DROP COLUMN phone;

-- Rename column
ALTER TABLE users RENAME COLUMN name TO full_name;

-- Modify column type
ALTER TABLE users ALTER COLUMN age TYPE VARCHAR(3);

-- Set default value
ALTER TABLE users ALTER COLUMN status SET DEFAULT 'active';

-- Add constraint
ALTER TABLE users ADD CONSTRAINT email_unique UNIQUE(email);

-- Drop constraint
ALTER TABLE users DROP CONSTRAINT email_unique;

-- Rename table
ALTER TABLE users RENAME TO customers;
```

### Drop Table

```sql
-- Drop table
DROP TABLE users;

-- Drop if exists
DROP TABLE IF EXISTS users;

-- Drop multiple tables
DROP TABLE users, orders, products;

-- Drop with cascade (remove dependencies)
DROP TABLE users CASCADE;
```

### Truncate Table

```sql
-- Delete all rows (faster than DELETE)
TRUNCATE TABLE users;

-- Truncate with cascade
TRUNCATE TABLE users CASCADE;

-- Reset sequence
TRUNCATE TABLE users RESTART IDENTITY;
```

---

## DATA OPERATIONS

### INSERT

```sql
-- Insert single row
INSERT INTO users (name, email, age) 
VALUES ('John', 'john@example.com', 30);

-- Insert multiple rows
INSERT INTO users (name, email, age) VALUES
('Alice', 'alice@example.com', 25),
('Bob', 'bob@example.com', 28),
('Charlie', 'charlie@example.com', 35);

-- Insert from select
INSERT INTO users_backup SELECT * FROM users WHERE age > 30;

-- Insert with default values
INSERT INTO users (name) VALUES ('John');
```

### SELECT

```sql
-- Select all
SELECT * FROM users;

-- Select specific columns
SELECT name, email FROM users;

-- Select with WHERE
SELECT * FROM users WHERE age > 30;

-- Select with AND/OR
SELECT * FROM users WHERE age > 30 AND status = 'active';
SELECT * FROM users WHERE age > 30 OR name LIKE 'J%';

-- Select with IN
SELECT * FROM users WHERE id IN (1, 3, 5);

-- Select with BETWEEN
SELECT * FROM users WHERE age BETWEEN 25 AND 35;

-- Select with LIKE
SELECT * FROM users WHERE name LIKE 'Jo%';
SELECT * FROM users WHERE email LIKE '%@example.com';

-- Select distinct
SELECT DISTINCT status FROM users;

-- Select with ORDER BY
SELECT * FROM users ORDER BY age DESC;
SELECT * FROM users ORDER BY name ASC, age DESC;

-- Select with LIMIT
SELECT * FROM users LIMIT 10;

-- Select with OFFSET
SELECT * FROM users LIMIT 10 OFFSET 20;

-- Select with GROUP BY
SELECT status, COUNT(*) FROM users GROUP BY status;

-- Select with HAVING
SELECT status, COUNT(*) FROM users GROUP BY status HAVING COUNT(*) > 5;

-- Select with JOIN
SELECT u.name, o.amount FROM users u
JOIN orders o ON u.id = o.user_id;

-- Left join
SELECT u.name, o.amount FROM users u
LEFT JOIN orders o ON u.id = o.user_id;

-- Count records
SELECT COUNT(*) FROM users;

-- Sum/Avg/Min/Max
SELECT SUM(amount) FROM orders;
SELECT AVG(age) FROM users;
SELECT MIN(age), MAX(age) FROM users;
```

### UPDATE

```sql
-- Update single row
UPDATE users SET age = 31 WHERE id = 1;

-- Update multiple columns
UPDATE users SET age = 30, status = 'active' WHERE id = 1;

-- Update multiple rows
UPDATE users SET status = 'inactive' WHERE age > 50;

-- Update with calculation
UPDATE orders SET total = amount * quantity WHERE status = 'pending';

-- Update with CASE
UPDATE users SET level = 
  CASE 
    WHEN age < 25 THEN 'junior'
    WHEN age < 35 THEN 'mid'
    ELSE 'senior'
  END;

-- Update from another table
UPDATE users SET status = 'vip' 
WHERE id IN (SELECT user_id FROM orders WHERE amount > 1000);
```

### DELETE

```sql
-- Delete all rows
DELETE FROM users;

-- Delete specific rows
DELETE FROM users WHERE id = 1;

-- Delete multiple rows
DELETE FROM users WHERE age > 60;

-- Delete with condition
DELETE FROM orders WHERE status = 'cancelled' AND created_at < NOW() - INTERVAL '30 days';
```

---

## INDEXES

```sql
-- Create index
CREATE INDEX idx_users_email ON users(email);

-- Create unique index
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);

-- Create multi-column index
CREATE INDEX idx_users_name_age ON users(name, age);

-- Create index with condition
CREATE INDEX idx_active_users ON users(id) WHERE status = 'active';

-- List indexes
SELECT * FROM pg_indexes WHERE tablename = 'users';

-- Drop index
DROP INDEX idx_users_email;

-- Reindex
REINDEX INDEX idx_users_email;
```

---

## USER & ROLES

```sql
-- Create user
CREATE USER username WITH PASSWORD 'password';

-- Create user with options
CREATE USER username WITH PASSWORD 'password' CREATEDB CREATEROLE;

-- Alter user password
ALTER USER username WITH PASSWORD 'new_password';

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON users TO username;
GRANT ALL PRIVILEGES ON DATABASE mydb TO username;

-- Grant on all tables
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO username;

-- Revoke permissions
REVOKE SELECT ON users FROM username;

-- List users
SELECT * FROM pg_user;
\du

-- Drop user
DROP USER username;

-- Drop user if exists
DROP USER IF EXISTS username;
```

---

## VIEWS

```sql
-- Create view
CREATE VIEW active_users AS
SELECT * FROM users WHERE status = 'active';

-- Create or replace view
CREATE OR REPLACE VIEW active_users AS
SELECT * FROM users WHERE status = 'active';

-- Query view
SELECT * FROM active_users;

-- Drop view
DROP VIEW active_users;

-- Drop view with cascade
DROP VIEW active_users CASCADE;

-- List views
\dv
SELECT * FROM information_schema.views;
```

---

## STORED PROCEDURES & FUNCTIONS

```sql
-- Create function
CREATE FUNCTION add_user(name VARCHAR, email VARCHAR)
RETURNS INT AS $$
DECLARE
  user_id INT;
BEGIN
  INSERT INTO users (name, email) VALUES (name, email) RETURNING id INTO user_id;
  RETURN user_id;
END;
$$ LANGUAGE plpgsql;

-- Call function
SELECT add_user('John', 'john@example.com');

-- Drop function
DROP FUNCTION add_user;

-- Drop function with parameters
DROP FUNCTION add_user(VARCHAR, VARCHAR);
```

---

## TRANSACTIONS

```sql
-- Start transaction
BEGIN;

-- Commit transaction
COMMIT;

-- Rollback transaction
ROLLBACK;

-- Example transaction
BEGIN;
INSERT INTO users (name, email) VALUES ('John', 'john@example.com');
UPDATE orders SET status = 'completed' WHERE id = 1;
COMMIT;

-- Rollback example
BEGIN;
DELETE FROM users WHERE id = 1;
ROLLBACK;

-- Savepoint
BEGIN;
SAVEPOINT sp1;
DELETE FROM users WHERE id = 1;
ROLLBACK TO SAVEPOINT sp1;
COMMIT;
```

---

## BACKUP & RESTORE

### Backup

```bash
# Backup single database
pg_dump -U username mydb > backup.sql

# Backup with compression
pg_dump -U username mydb | gzip > backup.sql.gz

# Backup all databases
pg_dumpall -U username > all_databases.sql

# Backup specific table
pg_dump -U username -t users mydb > users_backup.sql

# Backup with data only (no schema)
pg_dump -U username -a mydb > data_only.sql

# Backup with schema only (no data)
pg_dump -U username -s mydb > schema_only.sql
```

### Restore

```bash
# Restore database
psql -U username -d mydb < backup.sql

# Restore from compressed backup
gunzip -c backup.sql.gz | psql -U username -d mydb

# Restore all databases
psql -U username < all_databases.sql

# Restore specific table
psql -U username -d mydb < users_backup.sql
```

---

## USEFUL QUERIES

### Database Information

```sql
-- Database size
SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) 
FROM pg_database ORDER BY pg_database_size(pg_database.datname) DESC;

-- Table size
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) 
FROM pg_tables ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Index size
SELECT schemaname, indexname, pg_size_pretty(pg_relation_size(indexrelid)) 
FROM pg_indexes ORDER BY pg_relation_size(indexrelid) DESC;

-- List all schemas
SELECT schema_name FROM information_schema.schemata;

-- PostgreSQL version
SELECT version();

-- Current user
SELECT current_user;

-- Current database
SELECT current_database();
```

### Performance

```sql
-- Slow queries (requires log_min_duration_statement set)
SELECT query, mean_time, calls FROM pg_stat_statements 
ORDER BY mean_time DESC LIMIT 10;

-- Table statistics
SELECT schemaname, tablename, seq_scan, seq_tup_read, idx_scan 
FROM pg_stat_user_tables ORDER BY seq_scan DESC;

-- Missing indexes
SELECT schemaname, tablename, attname, n_distinct, correlation 
FROM pg_stats WHERE schemaname != 'pg_catalog' 
ORDER BY abs(correlation) DESC LIMIT 10;

-- Active connections
SELECT usename, datname, count(*) 
FROM pg_stat_activity GROUP BY usename, datname;

-- Cache hit ratio
SELECT 
  sum(heap_blks_read) as heap_read, 
  sum(heap_blks_hit) as heap_hit, 
  sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM pg_statio_user_tables;
```

---

## DOCKER COMMANDS

### Start PostgreSQL

```bash
# Run PostgreSQL container
docker run --name postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DB=mydb \
  -p 5432:5432 \
  -d postgres:latest

# Stop container
docker stop postgres

# Start container
docker start postgres

# Remove container
docker rm postgres

# Connect to running container
docker exec -it postgres psql -U postgres -d mydb

# View logs
docker logs postgres

# Stop all containers
docker stop $(docker ps -q)

# Remove all containers
docker rm $(docker ps -aq)
```

### With Docker Compose

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:latest
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

---

## COMMON PATTERNS

### Date/Time

```sql
-- Current date/time
SELECT NOW();
SELECT CURRENT_DATE;
SELECT CURRENT_TIME;

-- Add interval
SELECT NOW() + INTERVAL '1 day';
SELECT NOW() + INTERVAL '1 month';
SELECT NOW() - INTERVAL '30 days';

-- Extract parts
SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());
SELECT EXTRACT(DAY FROM NOW());

-- Format date
SELECT TO_CHAR(NOW(), 'YYYY-MM-DD HH:MI:SS');
SELECT TO_CHAR(NOW(), 'DD/MM/YYYY');
```

### String Functions

```sql
-- Concatenate
SELECT CONCAT('Hello', ' ', 'World');
SELECT 'Hello' || ' ' || 'World';

-- Length
SELECT LENGTH('Hello');

-- Uppercase/Lowercase
SELECT UPPER('hello');
SELECT LOWER('HELLO');

-- Trim
SELECT TRIM('  Hello  ');
SELECT LTRIM('  Hello');
SELECT RTRIM('Hello  ');

-- Substring
SELECT SUBSTRING('Hello World', 1, 5);
SELECT SUBSTR('Hello World', 7, 5);

-- Replace
SELECT REPLACE('Hello World', 'World', 'PostgreSQL');

-- Split
SELECT STRING_TO_ARRAY('a,b,c', ',');
```

### Type Conversion

```sql
-- Convert to integer
SELECT CAST('123' AS INT);
SELECT '123'::INT;

-- Convert to text
SELECT CAST(123 AS VARCHAR);
SELECT 123::VARCHAR;

-- Convert to date
SELECT CAST('2024-01-20' AS DATE);
SELECT '2024-01-20'::DATE;
```

---

## PSQL CONNECTION STRING

```bash
# Environment variable
export PGPASSWORD="password"

# Connection string
postgresql://user:password@localhost:5432/database

# From Java/Spring Boot
jdbc:postgresql://localhost:5432/mydb
```

---

## QUICK TIPS

```bash
# Check PostgreSQL status
systemctl status postgresql

# Restart PostgreSQL
systemctl restart postgresql

# Start PostgreSQL
systemctl start postgresql

# Stop PostgreSQL
systemctl stop postgresql

# List running PostgreSQL processes
ps aux | grep postgres

# Check PostgreSQL version
psql --version

# PostgreSQL log location
# Linux: /var/log/postgresql/
# Mac: /usr/local/var/log/

# Configuration file
# Linux: /etc/postgresql/
# Mac: /usr/local/etc/postgresql.conf
```

---

## HELPFUL PSQL SETTINGS

```sql
-- Enable query timing
\timing

-- Expand output (vertical display)
\x

-- Set null display
\pset null '[NULL]'

-- Set table format
\pset format aligned

-- Show line numbers in query results
\pset linestyle unicode
```

---

**Happy querying! 🚀**
