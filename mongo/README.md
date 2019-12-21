# Instructions for downloading and compiling the Docker image

Compiling the docker image.

```sh
cd adsoft/mongo
docker build -t adsoft/mongo:1.0.0 .
```

Start the container of the application.

```sh
mkdir -p /docker/adsoft/mongo

docker run -d -p 21017:21017 --name mongo \
-v /docker/adsoft/mongo:/data/db \
-e MONGO_INITDB_ROOT_USERNAME:"adsoft" \
-e MONGO_INITDB_ROOT_PASSWORD:"adsoft" \
adsoft/mongo:1.0.0
```

View the mongo log

```sh
docker logs -f mongo
```

If you need to remove the container, use the command below.

```sh
docker rm -f mongo
```

Restarting the container on boot or on failure.

```sh
docker update --restart always mongo
```
