# Use a secure base image (Latest stable Python with Alpine)
FROM python:3.10-alpine AS builder

# Set environment variables for better security and logging
ENV PYTHONUNBUFFERED=1

# Set a working directory
WORKDIR /app

# Install system dependencies (only required for building)
RUN apk add --no-cache \
    build-base \
    libffi-dev \
    openssl-dev \
    musl-dev \
    && pip install --upgrade pip setuptools wheel

# Copy requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# -----------------------------------------
# Create a smaller final image (Runtime only)
# -----------------------------------------
FROM python:3.10-alpine AS final

# Set working directory
WORKDIR /app

# Copy installed dependencies from builder stage
COPY --from=builder /usr/local/lib/python3.10 /usr/local/lib/python3.10
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application source code
COPY . .

# Create and switch to a non-root user
RUN adduser -D myuser
USER myuser

# Expose the application port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
