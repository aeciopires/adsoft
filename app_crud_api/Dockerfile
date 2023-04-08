FROM node:11-alpine
# Base image

# Image Information
LABEL maintener="AD Soft" \
      author="Aécio Pires and André Déo" \
      create="2020/01/03" \
      version="1.0.0" \
      description="Especify the image Docker of app" \
      license="gpl-v3"

# Getting the app
RUN mkdir /home/app
COPY crud /home/app
WORKDIR /home/app
RUN npm install --quiet
RUN npm install nodemon -g --quiet

# Expose the app port
EXPOSE 9000

# Starting the service when starting the container
CMD ["nodemon", "-L", "--watch", ".", "index.js"]
