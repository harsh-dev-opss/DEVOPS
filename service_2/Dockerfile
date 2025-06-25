FROM python:3.9-slim

WORKDIR /app

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy Python app files
COPY . .

# Install Flask
RUN pip install --no-cache-dir flask

# Verify Python and Flask installation
RUN python --version && pip show flask

# Expose port
EXPOSE 8002

# Run the app with unbuffered output
CMD ["python", "-u", "app.py"]
