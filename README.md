# Docker Compose Assignment

This project implements a Docker Compose-based application consisting of three services: an Nginx reverse proxy, a Go-based `service_1`, and a Python Flask-based `service_2`. The services are orchestrated using Docker Compose, with health checks to ensure reliability and a test script to validate functionality. The Nginx proxy routes requests to the appropriate services, and the setup includes logging and modular configuration for scalability.

## Table of Contents
- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Services](#services)
- [Setup Instructions](#setup-instructions)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Submission](#submission)
- [Bonus Features](#bonus-features)

## Project Overview
The application consists of:
- **Nginx**: Acts as a reverse proxy, routing requests to `service_1` and `service_2`. Exposed on port `8080`.
- **Service_1**: A Go-based service listening on port `8001`, providing `/ping` and `/hello` endpoints.
- **Service_2**: A Python Flask-based service listening on port `8002`, providing `/ping` and `/hello` endpoints.
- **Docker Compose**: Orchestrates the services with health checks and a bridge network (`app-network`).
- **Test Script**: A Bash script (`test.sh`) validates the health of Nginx and the functionality of service endpoints.

### Endpoints
- `http://localhost:8080/health`: Returns `"Nginx is running"` (plain text).
- `http://localhost:8080/service1/ping`: Returns `{"status":"ok","service":"1"}` (JSON).
- `http://localhost:8080/service1/hello`: Returns `{"message":"Hello from Service 1"}` (JSON).
- `http://localhost:8080/service2/ping`: Returns `{"status":"ok","service":"2"}` (JSON).
- `http://localhost:8080/service2/hello`: Returns `{"message":"Hello from Service 2"}` (JSON).

## Prerequisites
- **Docker**: Version 20.10 or higher.
- **Docker Compose**: Version 1.29.2 or higher (recommend upgrading to v2.x).
- **Git**: For cloning the repository.
- **Bash**: For running the test script.
- **Operating System**: Linux (Ubuntu recommended), macOS, or Windows with WSL2.

To check versions:
```bash
docker --version
docker-compose --version
git --version

Project Structure
.
├── docker-compose.yml       # Docker Compose configuration
├── nginx
│   ├── nginx.conf          # Nginx configuration
│   └── Dockerfile          # Nginx Dockerfile
├── service_1
│   ├── Dockerfile          # Service_1 Dockerfile
│   ├── main.go             # Go application source
│   ├── go.mod              # Go module dependencies
│   └── README.md           # Service_1 documentation
├── service_2
│   ├── Dockerfile          # Service_2 Dockerfile
│   ├── app.py              # Flask application source
│   └── README.md           # Service_2 documentation
├── README.md               # Project documentation
└── test.sh                 # Test script for endpoint validation

Services
Nginx

Role: Reverse proxy.
Port: 8080 (host) → 8080 (container).
Health Check: Runs nginx -t to validate configuration.
Configuration: Defined in nginx/nginx.conf with upstream blocks for service_1 and service_2.
Dependencies: Waits for service_1 and service_2 to be healthy.

Service_1

Role: Go-based API.
Port: 8001 (internal).
Endpoints:
/ping: Returns {"status":"ok","service":"1"}.
/hello: Returns {"message":"Hello from Service 1"}.


Health Check: Uses curl -f http://localhost:8001/ping.
Dockerfile: Based on golang:1.22-alpine, includes curl for health checks.

Service_2

Role: Python Flask-based API.
Port: 8002 (internal).
Endpoints:
/ping: Returns {"status":"ok","service":"2"}.
/hello: Returns {"message":"Hello from Service 2"}.


Health Check: Uses curl -f http://localhost:8002/ping.
Dockerfile: Based on python:3.9-slim, includes curl and Flask.

Setup Instructions

Clone the Repository:
git clone <repository-url>
cd Assignment


Verify Files:Ensure the project structure matches the one above.

Clean Up Existing Containers:
docker-compose down
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -q 'assignment_*')
docker system prune -f


Start Services:Run in detached mode to keep services in the background:
docker-compose up -d --build


Check Service Status:Verify all services are running and healthy:
docker-compose ps

Expected output:
Name                    State               Health
assignment_nginx_1      Up                  healthy
assignment_service_1_1   Up                  healthy
assignment_service_2_1   Up                  healthy


View Logs (if needed):
docker-compose logs


Stop Services:
docker-compose down



Testing

Run Test Script:The test.sh script validates all endpoints:
chmod +x test.sh
./test.sh

Expected output:
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


Manual Testing:Test endpoints directly:
curl http://localhost:8080/health
curl http://localhost:8080/service1/ping
curl http://localhost:8080/service1/hello
curl http://localhost:8080/service2/ping
curl http://localhost:8080/service2/hello



Troubleshooting

Unhealthy Services:

Check logs: docker-compose logs <service_name>.
Verify curl is installed:docker exec -it assignment_service_1_1 sh -c "curl --version"
docker exec -it assignment_service_2_1 bash -c "curl --version"


Test health checks:docker exec -it assignment_service_1_1 sh -c "curl -f http://localhost:8001/ping"
docker exec -it assignment_service_2_1 bash -c "curl -f http://localhost:8002/ping"




Nginx Fails to Start:

Check configuration: docker run --rm -v $(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf:ro nginx:latest nginx -t.
Verify service_1 and service_2 are healthy (docker-compose ps).


Test Script Fails:

Ensure services are running: docker-compose ps.
Check endpoint responses manually with curl.
Verify nginx.conf routes correctly.


Docker Compose Version:If issues persist, upgrade Docker Compose:
sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


Additional Files:Check the Google Drive folder for missing files (e.g., requirements.txt for service_2).


Submission

Commit Changes:
git add .
git commit -m "Complete Docker Compose assignment with Nginx, Service_1, Service_2, and test script"
git push origin main


Submit Repository:

Submit the repository URL via the Google Form: https://forms.gle/6LmZR5b2HsfDJLXS6
Ensure the repository is accessible (public or shared with the instructor).



Bonus Features

Health Checks: Implemented for all services (nginx -t, curl -f for services).
Logging: Configured with JSON driver, 10MB max size, and 3 file rotations.
Modular Configuration: Separate nginx.conf, Dockerfiles, and docker-compose.yml for scalability.
Test Script: Enhanced with colored output and clear pass/fail indicators.
Robust Setup: Handles JSON key ordering, 301 redirects, and service dependencies.


