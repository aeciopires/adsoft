# Instructions for downloading and compiling the Docker image

Attention: 

1) The application run here was developed by Lamek and is very well documented in the links below.

* https://medium.com/@lameckanao/fazendo-um-crud-com-node-js-mongodb-e-docker-70ee6c8da8ca
* https://github.com/lamecksilva/Simple-CRUD-API

2) Install Docker and Docker Compose following the instructions on the [REQUIREMENTS.md](REQUIREMENTS.md) file.

3) Start the containers.

```sh
sudo mkdir -p /docker/adsoft/db_crud_api

cd adsoft/app_crud_api

docker-compose up --build
```

4) Access the app in the URL http://localhost:9000 (for HTTP).

5) Stop the containers.

```sh
docker-compose down
```

PS.: Disabling authentication of mongodb: https://stackoverflow.com/questions/52373098/disable-default-authentication-in-mongo-docker
