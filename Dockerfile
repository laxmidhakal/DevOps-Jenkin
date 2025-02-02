FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.11-slim

WORKDIR /app
# Copy the installed packages from the builder stage
COPY --from=builder /root/.local /root/.local
COPY . .

# Create a new user and group
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Change ownership of the application directory
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

EXPOSE 5000
CMD ["python", "app.py"]
