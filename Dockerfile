# Use Python 3.7 Alpine as the base image
FROM python:3.7-alpine

# Set environment variables to ensure Python output is not buffered
ENV PYTHONUNBUFFERED=1

# Install system dependencies for building Python packages
RUN apk update && apk add --no-cache build-base

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code into the container
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Run the Python app
CMD ["python", "app.py"]
