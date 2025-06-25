# Docker Compose Assignment

![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Go](https://img.shields.io/badge/Go-00ADD8?logo=go&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)

This project is a **Docker Compose-based application** designed to demonstrate container orchestration with three services: an **Nginx reverse proxy**, a **Go-based Service 1**, and a **Python Flask-based Service 2**. The services are managed using Docker Compose, featuring health checks for reliability, a test script for validation, and logging for monitoring. The Nginx proxy routes requests to the appropriate services, ensuring a scalable and modular setup.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Services and Endpoints](#services-and-endpoints)
- [Setup Instructions](#setup-instructions)
- [Testing the Application](#testing-the-application)
- [Troubleshooting](#troubleshooting)
- [Submission](#submission)
- [Bonus Features](#bonus-features)

## Overview
The application orchestrates three services using **Docker Compose**:
- **Nginx**: Routes incoming requests to `service_1` or `service_2` and exposes a health check endpoint. Runs on port `8080`.
- **Service_1**: A lightweight Go API providing `/ping` and `/hello` endpoints, listening on port `8001` (internal).
- **Service_2**: A Python Flask API providing `/ping` and `/hello` endpoints, listening on port `8002` (internal).

The services communicate over a bridge network (`app-network`), with health checks ensuring reliability. A Bash script (`test.sh`) validates all endpoints, and logging is configured for debugging.

## Prerequisites
To run this project, ensure you have the following installed:
- **Docker**: Version 20.10 or higher.
- **Docker Compose**: Version 1.29.2 or higher (v2.x recommended).
- **Git**: For cloning the repository.
- **Bash**: For running `test.sh`.
- **Operating System**: Linux (Ubuntu recommended), macOS, or Windows with WSL2.

Verify installations:
```bash
docker --version
docker-compose --version
git --version
```

**Install Prerequisites (Ubuntu)**:
```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose git
sudo systemctl enable docker
sudo systemctl start docker
```

## Project Structure
```
.
├── docker-compose.yml       # Configures Docker Compose services and network
├── nginx/
│   ├── nginx.conf          # Nginx reverse proxy configuration
│   └── Dockerfile          # Builds Nginx with curl for health checks
├── service_1/
│   ├── Dockerfile          # Builds Go-based Service 1 with curl
│   ├── main.go             # Go application source code
│   ├── go.mod              # Go module dependencies
│   └── README.md           # Service-specific documentation
├── service_2/
│   ├── Dockerfile          # Builds Flask-based Service 2 with curl
│   ├── app.py              # Flask application source code
│   └── README.md           # Service-specific documentation
├── test.sh                 # Bash script to test all endpoints
└── README.md               # Project documentation (this file)
```

## Services and Endpoints
| Service     | Port (Internal) | Endpoint              | Response (Content-Type)                     |
|-------------|-----------------|-----------------------|---------------------------------------------|
| **Nginx**   | 8080            | `/health`             | `Nginx is running` (text/plain)             |
| **Service_1** | 8001          | `/service1/ping`      | `{"status":"ok","service":"1"}` (application/json) |
|             |                 | `/service1/hello`     | `{"message":"Hello from Service 1"}` (application/json) |
| **Service_2** | 8002          | `/service2/ping`      | `{"status":"ok","service":"2"}` (application/json) |
|             |                 | `/service2/hello`     | `{"message":"Hello from Service 2"}` (application/json) |

- **Nginx**: Routes requests to `/service1/*` and `/service2/*`, with health check via `nginx -t`.
- **Service_1**: Go-based API with health check using `curl -f http://localhost:8001/ping`.
- **Service_2**: Flask-based API with health check using `curl -f http://localhost:8002/ping`.

## Setup Instructions
1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd Assignment
   ```

2. **Verify Project Structure**:
   Ensure all files match the structure above.

3. **Clean Up Existing Containers**:
   Remove old containers and images to avoid conflicts:
   ```bash
   docker-compose down
   docker rm -f $(docker ps -aq)
   docker rmi -f $(docker images -q 'assignment_*')
   docker system prune -f
   ```

4. **Start Services**:
   Build and run services in the background:
   ```bash
   docker-compose up -d --build
   ```

5. **Verify Service Status**:
   Check that all services are running and healthy:
   ```bash
   docker-compose ps
   ```
   **Expected Output**:
   ```
   Name                    State               Health
   assignment_nginx_1      Up                  healthy
   assignment_service_1_1   Up                  healthy
   assignment_service_2_1   Up                  healthy
   ```

6. **View Logs (Optional)**:
   Inspect logs for debugging:
   ```bash
   docker-compose logs
   ```

7. **Stop Services**:
   Stop and remove containers when done:
   ```bash
   docker-compose down
   ```

## Testing the Application
1. **Run Automated Tests**:
   The `test.sh` script validates all endpoints with colored output:
   ```bash
   chmod +x test.sh
   ./test.sh
   ```
   **Expected Output**:
   ```
   Starting API Tests...

   ==============================
   Testing Nginx Health Check
   ==============================
   [Health Check] PASSED: Status 200, expected content found

   ==============================
   Testing Service 1
   ==============================
   [Service 1 Ping] PASSED: Status 200, expected content found
   [Service 1 Hello] PASSED: Status 200, expected content found

   ==============================
   Testing Service 2
   ==============================
   [Service 2 Ping] PASSED: Status 200, expected content found
   [Service 2 Hello] PASSED: Status 200, expected content found

   ==============================
   All Tests Passed Successfully!
   ==============================
   ```

2. **Manual Testing**:
   Test endpoints directly to verify responses:
   ```bash
   curl http://localhost:8080/health
   curl http://localhost:8080/service1/ping
   curl http://localhost:8080/service1/hello
   curl http://localhost:8080/service2/ping
   curl http://localhost:8080/service2/hello
   ```

## Troubleshooting
- **Unhealthy Services**:
  - Check logs: `docker-compose logs <service_name>`.
  - Verify `curl` installation:
    ```bash
    docker exec -it assignment_service_1_1 sh -c "curl --version"
    docker exec -it assignment_service_2_1 bash -c "curl --version"
    ```
  - Test health checks:
    ```bash
    docker exec -it assignment_service_1_1 sh -c "curl -f http://localhost:8001/ping"
    docker exec -it assignment_service_2_1 bash -c "curl -f http://localhost:8002/ping"
    ```

- **Nginx Fails to Start**:
  - Validate configuration:
    ```bash
    docker run --rm -v $(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf:ro nginx:latest nginx -t
    ```
  - Ensure `service_1` and `service_2` are healthy: `docker-compose ps`.

- **Test Script Fails**:
  - Verify services are running: `docker-compose ps`.
  - Test endpoints manually with `curl`.
  - Check `nginx.conf` for correct routing.

- **Docker Compose Version**:
  If issues persist, upgrade to v2.x:
  ```bash
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  ```

- **Missing Files**:
  Check the Google Drive folder for additional files (e.g., `requirements.txt` for `service_2`).

## Submission
1. **Commit Changes**:
   ```bash
   git add .
   git commit -m "Complete Docker Compose assignment with enhanced README"
   git push origin main
   ```

2. **Submit Repository**:
   - Submit the repository URL via the Google Form: [https://forms.gle/6LmZR5b2HsfDJLXS6](https://forms.gle/6LmZR5b2HsfDJLXS6).
   - Ensure the repository is **public** or shared with the instructor.

## Bonus Features
- **Health Checks**: Implemented for all services (`nginx -t` for Nginx, `curl -f` for services).
- **Logging**: JSON driver with 10MB max size and 3 file rotations.
- **Modular Configuration**: Separate `nginx.conf`, Dockerfiles, and `docker-compose.yml`.
- **Test Script**: Simplified with `curl` and `grep`, featuring colored output.
- **Robust Setup**: Handles JSON key ordering, 301 redirects, and service dependencies.
```]()
