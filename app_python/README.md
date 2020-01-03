# Instructions for downloading and compiling the Docker image

Attention: 

1) The application run here was developed by Andreyev Melo and is very well documented in the links below.

* https://github.com/andreyev/prometheus_hands-on/tree/demo/demo

Instructions for downloading and starting Docker Compose

```sh
sudo su

COMPOSE_VERSION=1.25.0

curl -L https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose

chmod 777 /usr/bin/docker-compose

exit
```

Start the containers.

```sh
sudo mkdir -p /docker/adsoft/mongo

cd adsoft/app_python

docker-compose up --build
```

Access the app in the URL http://localhost:8080 (for HTTP).

Stop the containers.

```sh
docker-compose down
```

For more information about Docker Compose visit:

* [https://docs.docker.com/compose/reference](https://docs.docker.com/compose/reference)
* [https://docs.docker.com/compose/compose-file](https://docs.docker.com/compose/compose-file)
* [https://docs.docker.com/engine/reference/builder](https://docs.docker.com/engine/reference/builder)
