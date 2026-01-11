# Use the Python image variant—no Ruby installed
FROM phusion/passenger-python312:0.9.35

# Baseimage init
ENV HOME /root
CMD ["/sbin/my_init"]

# Enable Nginx + Passenger
RUN rm -f /etc/service/nginx/down

# Remove default site and add our site
RUN rm -f /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf

# Create app directory and copy code as non-root
RUN mkdir -p /home/app/webapp
COPY --chown=app:app app/ /home/app/webapp/
COPY --chown=app:app requirements.txt /home/app/webapp/
COPY --chown=app:app passenger_wsgi.py /home/app/webapp/

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /home/app/webapp/requirements.txt

# Install curl for healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Optional: OS security updates
RUN apt-get update && apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Clean
