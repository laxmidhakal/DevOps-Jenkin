# Use the latest secure Python image
FROM python:3.12-slim-bookworm

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random

# Create a non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Set the working directory
WORKDIR /app

# Securely update system packages and remove vulnerabilities
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip securely
RUN python -m pip install --upgrade pip

# Copy dependency file first to leverage Docker caching
COPY requirements.txt .

# Install dependencies securely
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set permissions and switch to a non-root user
RUN chown -R appuser:appgroup /app
USER appuser

# Expose the application port
EXPOSE 5000

# Run securely
CMD ["python", "app.py"]
