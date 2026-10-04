# Instructions for building and running the Docker image

Attention:

1) The application run here was developed by Thalles Bastos and is documented in the links below (content in Portuguese).

* http://thbastos.com/blog/criando-uma-aplicacao-em-nodejs-1-inicio
* https://github.com/ThBastos/lista-contatos

> The code in this directory was updated to Node.js 24 (LTS), Express 5, Mongoose 9, MongoDB 8.0 and AngularJS 1.8.3. Because of that, the API routes and fields were translated to English (`/api/contacts` with the fields `name`, `email` and `phone`).

2) Install **Docker** and **Docker Compose** following the instructions on the [REQUIREMENTS.md](../REQUIREMENTS.md) file.

3) Start the containers.

```bash
sudo mkdir -p /docker/adsoft/db_app_nodejs

cd adsoft/app_nodejs

docker compose up --build
```

> The MongoDB data is stored in ``/docker/adsoft/db_app_nodejs``. Data files created by old MongoDB versions (for example, 4.x) are not compatible with MongoDB 8.0. If the directory has data from an old version, back it up and remove its content before starting the containers.

4) Access the app in the URL http://localhost:8080 (for HTTP).

The application connects to MongoDB using the ``MONGODB_URI`` environment variable (default: ``mongodb://db:27017/contact``).

API examples:

```bash
# List contacts
curl http://localhost:8080/api/contacts

# Create a contact
curl -X POST -H 'Content-Type: application/json' \
  -d '{"name":"John Doe","email":"john@example.com","phone":"(00) 0000-0000"}' \
  http://localhost:8080/api/contacts
```

5) Stop the containers.

```bash
docker compose down
```

References:

* https://hub.docker.com/_/mongo
* https://mongoosejs.com/docs/compatibility.html
* https://expressjs.com/en/guide/migrating-5.html
