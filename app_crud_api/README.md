# Instructions for building and running the Docker image

Attention:

1) The application run here was developed by Lameck and is documented in the links below (content in Portuguese).

* https://medium.com/@lameckanao/fazendo-um-crud-com-node-js-mongodb-e-docker-70ee6c8da8ca
* https://github.com/lamecksilva/Simple-CRUD-API

> The code in this directory was updated to Node.js 24 (LTS), Express 5, Mongoose 9 and MongoDB 8.0. Because of that, the API routes and fields were translated to English (`/api/cars` with the fields `brand` and `model`).

2) Install **Docker** and **Docker Compose** following the instructions on the [REQUIREMENTS.md](../REQUIREMENTS.md) file.

3) Start the containers.

```bash
sudo mkdir -p /docker/adsoft/db_crud_api

cd adsoft/app_crud_api

docker compose up --build
```

> The MongoDB data is stored in ``/docker/adsoft/db_crud_api``. Data files created by old MongoDB versions (for example, 4.x) are not compatible with MongoDB 8.0. If the directory has data from an old version, back it up and remove its content before starting the containers.

4) Access the API in the URL http://localhost:9000/api/cars (for HTTP).

The application connects to MongoDB using the ``MONGODB_URI`` environment variable (default: ``mongodb://db:27017/crud-node-mongo-docker``).

API examples:

```bash
# List cars
curl http://localhost:9000/api/cars

# Create a car
curl -X POST -H 'Content-Type: application/json' -d '{"brand":"Fiat","model":"Uno"}' http://localhost:9000/api/cars/new

# Update a car
curl -X PUT -H 'Content-Type: application/json' -d '{"brand":"Fiat","model":"Palio"}' http://localhost:9000/api/cars/edit/CAR_ID

# Delete a car
curl -X DELETE http://localhost:9000/api/cars/delete/CAR_ID
```

5) Stop the containers.

```bash
docker compose down
```
