# Instructions for building and running the Docker image

Attention:

1) The application run here was developed by Andreyev Melo and is documented in the link below.

* https://github.com/andreyev/prometheus_hands-on/tree/demo/demo

2) Install **Docker** and **Docker Compose** following the instructions on the [REQUIREMENTS.md](../REQUIREMENTS.md) file.

3) Start the container.

```bash
cd adsoft/app_python

docker compose up --build
```

4) Access the app at http://localhost:8002 and the Prometheus metrics at http://localhost:8001.

> Each request to the app sleeps a random time between 0 and 9 seconds and fails randomly in about 20% of the requests, so that the metrics `demo_sum`, `demo_count`, `demo_exceptions_count` and `demo_last_time_seconds` change.

5) Stop the container.

```bash
docker compose down
```
