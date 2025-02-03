FROM python:3.12-slim

# Set up a non-root user first
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

WORKDIR /app

# Update packages securely
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install dependencies
COPY requirements.txt .
RUN python -m pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Set ownership and switch user
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 5000
CMD ["python", "app.py"]
