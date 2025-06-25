#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print test header
print_header() {
    echo -e "${YELLOW}=============================="
    echo -e "Testing $1"
    echo -e "==============================${NC}"
}

# Function to check response and status code
check_response() {
    local url=$1
    local expected_content=$2
    local test_name=$3
    local response_file=$(mktemp)
    local status_code

    # Run curl and capture status code and response
    curl -s -o "$response_file" -w "%{http_code}" "$url" > "${response_file}.status" || {
        echo -e "${RED}[$test_name] FAILED: Unable to connect to $url${NC}"
        rm "$response_file" "${response_file}.status"
        exit 1
    }

    status_code=$(cat "${response_file}.status")
    if [ "$status_code" != "200" ]; then
        echo -e "${RED}[$test_name] FAILED: Expected status 200, got $status_code${NC}"
        cat "$response_file"
        rm "$response_file" "${response_file}.status"
        exit 1
    fi

    # Check response content
    if grep -q "$expected_content" "$response_file"; then
        echo -e "${GREEN}[$test_name] PASSED: Status 200, expected content found${NC}"
    else
        echo -e "${RED}[$test_name] FAILED: Expected content '$expected_content' not found${NC}"
        cat "$response_file"
        rm "$response_file" "${response_file}.status"
        exit 1
    fi

    rm "$response_file" "${response_file}.status"
}

# Start tests
echo -e "${YELLOW}Starting API Tests...${NC}\n"

# Test Nginx health check
print_header "Nginx Health Check"
check_response "http://localhost:8080/health" "Nginx is running" "Health Check"

# Test Service 1 endpoints
print_header "Service 1"
check_response "http://localhost:8080/service1/ping" '"status":"ok"' "Service 1 Ping"
check_response "http://localhost:8080/service1/hello" '"message":"Hello from Service 1"' "Service 1 Hello"

# Test Service 2 endpoints
print_header "Service 2"
check_response "http://localhost:8080/service2/ping" '"status":"ok"' "Service 2 Ping"
check_response "http://localhost:8080/service2/hello" '"message":"Hello from Service 2"' "Service 2 Hello"

# All tests passed
echo -e "\n${GREEN}=============================="
echo -e "All Tests Passed Successfully!"
echo -e "==============================${NC}"
