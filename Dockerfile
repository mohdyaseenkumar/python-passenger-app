# Use official Python base image
FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nginx curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /home/app/webapp

# Copy application files
COPY requirements.txt .
COPY passenger_wsgi.py .
COPY app/ ./app/
COPY webapp.conf /etc/nginx/conf.d/webapp.conf

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default

# Expose port
EXPOSE 80

# Start Gunicorn + Nginx
CMD service nginx start && gunicorn -w 4 -b 0.0.0.0:8000 passenger_wsgi:application
