FROM python:3.12-slim-bookworm

# Set up a non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

WORKDIR /app

# Securely update system packages
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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
