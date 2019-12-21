# Instructions for downloading and compiling the Docker image

Attention: 

1) The application run here was developed by Thalles Bastos and is very well documented in the links below.

* http://thbastos.com/blog/criando-uma-aplicacao-em-nodejs-1-inicio
* https://github.com/ThBastos/lista-contatos

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
cd docker_compose/
docker-compose -f docker-compose_production.yml up
```

Access the app in the URL http://localhost:8080 (for HTTP).

Stop the containers.

```sh
cd docker_compose/
docker-compose down
```

For more information about Docker Compose visit:

* [https://docs.docker.com/compose/reference](https://docs.docker.com/compose/reference)
* [https://docs.docker.com/compose/compose-file](https://docs.docker.com/compose/compose-file)
* [https://docs.docker.com/engine/reference/builder](https://docs.docker.com/engine/reference/builder)
