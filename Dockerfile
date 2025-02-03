# Use Python 3.7 Alpine as the base image
FROM python:3.7-alpine

# # Set environment variables
# ENV PYTHONUNBUFFERED=1 \
#     PYTHONHASHSEED=random

# Install necessary utilities (groupadd, useradd) and update packages
RUN apk update && apk upgrade && apk add --no-cache \
    shadow \
    && rm -rf /var/cache/apk/*

# Create a non-root user and group
RUN groupadd -r appgroup && useradd -r -g appgroup -m appuser

# Set the working directory
WORKDIR /app

# Securely copy requirements and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the application code
COPY . .

# Change ownership of the application directory
RUN chown -R appuser:appgroup /app
USER appuser

# Expose the application port
EXPOSE 5000

# Run the Python application
CMD ["python", "app.py"]
