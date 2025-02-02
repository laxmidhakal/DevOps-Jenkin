FROM python:3.9.14-slim-bullseye
WORKDIR /app
# Create a new user and group
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Change ownership of the application directory
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

EXPOSE 5000
CMD ["python", "app.py"]
