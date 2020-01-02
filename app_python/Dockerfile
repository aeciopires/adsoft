# Original on:
# https://github.com/andreyev/prometheus_hands-on/blob/demo/demo/Dockerfile
# Tks Andreyev ;-)

FROM python:3

WORKDIR /usr/src/app

COPY demo.py .

RUN pip install prometheus_client

EXPOSE 8001
EXPOSE 8002

CMD [ "python", "./demo.py" ]