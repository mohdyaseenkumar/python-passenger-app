# Use the Python image variant—no Ruby installed
FROM phusion/passenger-python312:<VERSION>

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
RUN rvm-exec system bash -lc "pip3 install --no-cache-dir -r /home/app/webapp/requirements.txt"

# Optional: OS security updates
RUN apt-get update && apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Clean apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose HTTP
EXPOSE 80

# Optional healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s CMD curl -f http://localhost/health || exit 1

