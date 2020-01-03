# Original on:
# https://github.com/andreyev/prometheus_hands-on/blob/demo/demo/Dockerfile
# Thanks Andreyev ;-)

FROM python:3
# Base image

# Image Information
LABEL maintener="AD Soft" \
      author="Aécio Pires, Andre Déo and Andreyev Melo" \
      mail="aeciopires@gmail.com and andredeo@gmail.com" \
      create="2020/01/03" \
      version="1.0.0" \
      description="Especify the image Docker of app" \
      license="gpl-v3"

# Getting the app
WORKDIR /usr/src/app
COPY demo.py .
RUN pip install prometheus_client

# Expose the app port
EXPOSE 8001
EXPOSE 8002

# Starting the service when starting the container
CMD [ "python", "./demo.py" ]