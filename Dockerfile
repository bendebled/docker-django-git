# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.19

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Run apt-get update
RUN apt-get update

# Install Git
RUN apt-get install -y git

# Install Supervisor
RUN apt-get install -y supervisor

# Install/setup Python deps
RUN apt-get install -y python-pip
RUN pip install requests
RUN pip install gunicorn django

# Add Scripts
ADD scripts/start.sh /start.sh
ADD scripts/pull /usr/bin/pull
ADD scripts/push /usr/bin/push
ADD scripts/letsencrypt-setup /usr/bin/letsencrypt-setup
ADD scripts/letsencrypt-renew /usr/bin/letsencrypt-renew
ADD scripts/docker-hook /usr/bin/docker-hook
ADD scripts/hook-listener /usr/bin/hook-listener

# Setup permissions
RUN chmod 755 /usr/bin/pull && chmod 755 /usr/bin/push && chmod 755 /usr/bin/letsencrypt-setup && chmod 755 /usr/bin/letsencrypt-renew && chmod 755 /start.sh
RUN chmod +x /usr/bin/docker-hook
RUN chmod +x /usr/bin/hook-listener

RUN mkdir -p /var/www/html/

# Copy supervisor config
ADD conf/supervisord.conf /etc/supervisord.conf

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Run
EXPOSE 8000 8555
CMD ["/start.sh"]