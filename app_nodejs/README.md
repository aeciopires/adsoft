# Instructions for downloading and compiling the Docker image

Attention:

1) The application run here was developed by Thalles Bastos and is very well documented in the links below.

* http://thbastos.com/blog/criando-uma-aplicacao-em-nodejs-1-inicio
* https://github.com/ThBastos/lista-contatos

2) Install **Docker** and **Docker Compose** following the instructions on the [REQUIREMENTS.md](REQUIREMENTS.md) file.

3) Start the containers.

```bash
sudo mkdir -p /docker/adsoft/db_app_nodejs

cd adsoft/app_nodejs

docker-compose up --build
```

4) Access the app in the URL http://localhost:8080 (for HTTP).

5) Stop the containers.

```bash
docker-compose down
```

PS.: Disabling authentication of mongodb: https://stackoverflow.com/questions/52373098/disable-default-authentication-in-mongo-docker
