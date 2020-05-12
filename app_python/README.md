# Instructions for downloading and compiling the Docker image

Attention: 

1) The application run here was developed by Andreyev Melo and is very well documented in the links below.

* https://github.com/andreyev/prometheus_hands-on/tree/demo/demo

2) Install Docker and Docker Compose following the instructions on the [REQUIREMENTS.md](REQUIREMENTS.md) file.

3) Start the containers.

```sh
sudo mkdir -p /docker/adsoft/mongo

cd adsoft/app_python

docker-compose up --build
```

4) Access the app in the URL http://localhost:8080 (for HTTP).

5) Stop the containers.

```sh
docker-compose down
```

