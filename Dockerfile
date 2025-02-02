FROM python:3.11-alpine
WORKDIR /app
# Create a new user and group
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Change ownership of the application directory
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

EXPOSE 5000
CMD ["python", "app.py"]
