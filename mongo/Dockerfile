FROM mongo:latest
#Image base

# Image Information
LABEL maintener="AD Soft" \
      author="Aécio Pires and Andre Déo" \
      mail="aeciopires@gmail.com and andredeo@gmail.com" \
      create="2019/12/21" \
      version="1.0.0" \
      description="Especify the image Docker of mongo" \
      license="gpl-v3"

#---------------------------------#
# Variables
#---------------------------------#
# Environment variables (value changes at container initialization,
# if empty, will be given a default value)

# Defines the user of the mongo
ARG MONGO_INITDB_ROOT_USERNAME
ENV MONGO_INITDB_ROOT_USERNAME ${MONGO_INITDB_ROOT_USERNAME:-adsoft}

# Defines the password of the mongo
ARG MONGO_INITDB_ROOT_PASSWORD
ENV MONGO_INITDB_ROOT_PASSWORD ${MONGO_INITDB_ROOT_PASSWORD:-adsoft}

# Directory of data of the mongo
ARG MONGO_DATA_DIR
ENV MONGO_DATA_DIR ${MONGO_DATA_DIR:-/data/db}
#--------------------------------#

