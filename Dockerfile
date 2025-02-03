# Use a minimal, secure base image
FROM python:3.12.1-alpine

# Set environment variables for security
ENV PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Install dependencies securely
COPY requirements.txt .
RUN python -m pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set permissions and switch to non-root user
RUN chown -R appuser:appgroup /app
USER appuser

# Expose the application port
EXPOSE 5000

# Run securely
CMD ["python", "app.py"]
