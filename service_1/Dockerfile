FROM golang:1.22-alpine

WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl

# Copy Go app files
COPY . .

# Download dependencies
RUN go mod download

# Build the app
RUN go build -o main .

# Expose port
EXPOSE 8001

# Run the app
CMD ["./main"]
