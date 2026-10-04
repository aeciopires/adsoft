# Base image
FROM node:24-alpine

# Image Information
LABEL maintainer="AD Soft" \
      author="Aécio Pires and Andre Déo" \
      create="2019/12/21" \
      version="1.1.0" \
      description="Docker image of the contact list app" \
      license="gpl-v3"

#---------------------------------#
# Variables
#---------------------------------#
# Environment variables (value changes at container initialization,
# if empty, will be given a default value)

# Enable security settings: true or false
ARG ENABLE_SECURITY
ENV ENABLE_SECURITY=${ENABLE_SECURITY:-false}

ARG APP_VERSION
ENV APP_VERSION=${APP_VERSION:-1.1.0}

ARG app_port=8080
#--------------------------------#

# Getting the app
WORKDIR /home/node/app
COPY lista-contatos/package.json lista-contatos/package-lock.json ./

# Downloading the dependencies with npm command
RUN npm ci --omit=dev

COPY lista-contatos/ ./

# Expose the app port
EXPOSE ${app_port}

# Copying files and scripts into image
COPY run.sh /run.sh

# Setting the permission of scripts and files
RUN chown root:root /run.sh \
    && chmod 755 /run.sh

# Run the application as an unprivileged user
USER node

# Starting the service when starting the container
ENTRYPOINT ["/bin/sh", "-c", "/run.sh"]
