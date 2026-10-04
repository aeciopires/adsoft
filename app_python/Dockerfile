# Original on:
# https://github.com/andreyev/prometheus_hands-on/blob/demo/demo/Dockerfile
# Thanks Andreyev ;-)

# Base image
FROM python:3.14-slim

# Image Information
LABEL maintainer="AD Soft" \
      author="Aécio Pires, Andre Déo and Andreyev Melo" \
      create="2020/01/03" \
      version="1.1.0" \
      description="Docker image of the Prometheus instrumentation demo app" \
      license="gpl-v3"

# Getting the app
WORKDIR /usr/src/app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY demo.py .

# Expose the app ports
# 8001: Prometheus metrics
# 8002: Demo HTTP server
EXPOSE 8001
EXPOSE 8002

# Starting the service when starting the container
CMD [ "python", "./demo.py" ]
