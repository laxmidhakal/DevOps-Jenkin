# Use a secure and up-to-date Python base image
FROM python:3.11-alpine

# Set environment variables
# ENV PYTHONUNBUFFERED=1

# Set a working directory
WORKDIR /app

# Install necessary system dependencies
# RUN apk add --no-cache gcc musl-dev libffi-dev openssl-dev

# Upgrade pip and setuptools to secure versions
RUN pip install --upgrade pip setuptools==70.0.0

# Copy only requirements first (to leverage Docker caching)
COPY requirements.txt .

# Install Python dependencies securely
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application source code
COPY . .

# Create and switch to a non-root user for security
RUN adduser -D appuser
USER appuser

# Expose the application port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
