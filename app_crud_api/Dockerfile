# Base image
FROM node:24-alpine

# Image Information
LABEL maintainer="AD Soft" \
      author="Aécio Pires and André Déo" \
      create="2020/01/03" \
      version="1.1.0" \
      description="Docker image of the CRUD API app" \
      license="gpl-v3"

# Getting the app
WORKDIR /home/app
COPY crud/package.json crud/package-lock.json ./
RUN npm ci --quiet

COPY crud/ ./

# Expose the app port
EXPOSE 9000

# Starting the service when starting the container.
# nodemon restarts the app when a file changes.
CMD ["npx", "nodemon", "-L", "--watch", ".", "index.js"]
