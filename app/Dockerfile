FROM node:lts-alpine
# Image base

# Image Information
LABEL maintener="AD Soft" \
      author="Aécio Pires and Andre Déo" \
      mail="aeciopires@gmail.com and andredeo@gmail.com" \
      create="2019/12/21" \
      version="1.0.0" \
      description="Especify the image Docker of app" \
      license="gpl-v3"

#---------------------------------#
# Variables
#---------------------------------#
# Environment variables (value changes at container initialization,
# if empty, will be given a default value)

# Enable security settings: true or false
ARG ENABLE_SECURITY
ENV ENABLE_SECURITY ${ENABLE_SECURITY:-false}

ARG APP_VERSION
ENV APP_VERSION ${APP_VERSION:-1.0.0}

ARG app_port=8080
#--------------------------------#

# Getting the app
RUN mkdir /home/node/app
COPY lista-contatos /home/node/app

# Downloading the dependences with npm command
WORKDIR  /home/node/app
RUN npm install

# Expose the app port
EXPOSE ${app_port}

# Copying files and scripts into image
COPY run.sh /run.sh

# Setting the permission of scripts and files
RUN chown root:root /run.sh \
    && chmod 755 /run.sh

# Starting the service when starting the container
ENTRYPOINT ["/bin/sh", "-c", "/run.sh"]
