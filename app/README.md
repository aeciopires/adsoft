# Instructions for downloading and compiling the Docker image

Attention: 

1) This container requires mongodb to work (will be shown how to start in the ../mongo/README.md directory)

2) The application run here was developed by Thalles Bastos and is very well documented in the links below.

* http://thbastos.com/blog/criando-uma-aplicacao-em-nodejs-1-inicio
* https://github.com/ThBastos/lista-contatos

Compiling the docker image.

```sh
cd adsoft/app
docker build --build-arg APP_VERSION=1.0.0 -t adsoft/app:1.0.0 .
```

Start the container of the application.

```sh
docker run -d -p 8080:8080 --name app adsoft/app:1.0.0
```

View the app log

```sh
docker logs -f app
```

If you need to remove the container, use the command below.

```sh
docker rm -f app
```

Restarting the container on boot or on failure.

```sh
docker update --restart always app
```