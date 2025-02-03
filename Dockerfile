FROM python:3.7-alpine

RUN apk update && apk add --no-cache \
    shadow \
    && rm -rf /var/cache/apk/*
# Create a new user and group
# RUN groupadd -r appgroup && useradd -r -g appgroup appuser
RUN groupadd -r appgroup && useradd -r -g appgroup -m appuser

WORKDIR /app




COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Set permissions and switch to the non-root user
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 5000
CMD ["python", "app.py"]
