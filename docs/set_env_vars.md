# Set environment variables


> Note: you don't need to set all of these variables. docker compose files already have default values for most of them. But in production you have to set at least `DJANGO_SECRET_KEY`.
---
Also, when running / deploying microservices, there is some requirements:

> - use exact the same `DJANGO_SECRET_KEY` for all microservices;
> - all services except `core` needs to have `AUTH_DB_URL` set to `core` service's `DATABASE_URL`;
> - all services except `core` needs to have `BROKER_URL` set to `core` service's `BROKER_URL`.

Other requirements will be explained below.


---
## General

### Core service
To get started with core service on local machine, you don't need to set any environment variables.
To deploy it to the server in production mode, `DJANGO_SECRET_KEY` will be enough:

```dotenv
DJANGO_SECRET_KEY=<some-strict-secret-key>
```

### Fork app / microservice
To run second / third / etc. microservice somewhere, including server in production mode, you need to set at least the following variables:

```dotenv
# The same secret key as in core service
DJANGO_SECRET_KEY=<some-strict-secret-key>

# Any free port, for example 5433
POSTGRES_PORT=

# Any free port, for example 5051
PGADMIN_PORT=

# Some unique label, for example "products"
DJ_MS_APP_LABEL=

# Core service's database url
AUTH_DB_URL=postgres://postgres:postgres@host.docker.internal:5432/postgres

# Core service's broker url
BROKER_URL=amqp://rabbitmq:rabbitmq@host.docker.internal:5672

# Any free port, for example 8001
DJANGO_WEB_PORT=
```


---
## Django

```dotenv
DJANGO_DEBUG=
```

In production, `DJANGO_DEBUG` is set to `False` in the `docker-compose.prod.yml` file.
In other cases default value will be `True` if not set.
You don't need to set it here unless you want to change it to `False` in _development environment_.

<br>

```dotenv
DJANGO_SECRET_KEY=
```

Use 1 strict secret key for all microservices.
You can generate one using one of these commands:
- `openssl rand -base64 40`
- `openssl rand -hex 40`
- `python -c 'import uuid; print(uuid.uuid4().hex)'`

<br>

```dotenv
DJANGO_TIME_ZONE=
```

Default timezone is `UTC`. You can change it to your local timezone. For example: `Europe/Warsaw`

<br>

```dotenv
DJANGO_LANGUAGE_CODE=
```

Default language is English (`en-us`). You can change it to your local language. For example: `ru`

<br>

```dotenv
DJANGO_REST_AUTH_TOKEN_TTL=
```

This project has expiring token implementation. You can set the token expiration time in seconds.
Default value is `86400` seconds (24 hours).


---
## Database

> By default, the project uses postgres database, built in the `docker-compose.yml` file.
> So you don't need to set this setting unless you want to use another database.
> Default value is `postgres://postgres:postgres@postgres:5432/postgres`

```dotenv
DATABASE_URL=postgres://postgres:postgres@postgres:5432/postgres
```

### Postgres

```dotenv
POSTGRES_PORT=
```

Which port should be exposed for **postgres** that built in the `docker-compose.yml` file?
Default value is `5432`.

<br>

```dotenv
POSTGRES_USER=
```

Default **postgres** username is `postgres`.

<br>

```dotenv
POSTGRES_PASSWORD=
```

Default **postgres** password is `postgres`.

<br>

```dotenv
POSTGRES_DB=
```

Default **postgres** database is `postgres`.


---
## Redis

```dotenv
REDIS_URL=
```

By default, the project uses redis, built in the `docker-compose.yml` file.
So you don't need to set this setting unless you want to use another redis.
Default value is `redis://redis:6379`
Don't set database number in the url.


---
## Microservices

```dotenv
DJ_MS_CORE_VERSION=
```

Which base image should be used for building the service? 
By default, `latest` tag is used.
This setting must be exactly the same in every microservice.

<br>

```dotenv
DJ_MS_APP_LABEL=
```

In main microservice this setting should be skipped.
In every other microservice you should set a unique label for the app.
It will be used for building appropriate docker image and as a url prefix.
For example: label `products` will result in the following docker image: `dj-ms-products:latest`.
And the url for the service will be: `http://localhost:8000/products/`

<br>

```dotenv
AUTH_DB_URL=
```

This is the most interesting part of the project! In core microservice this setting must be skipped.
But! In other microservices you should set this setting to the core microservice database url.
This allows you to use the same authentication database in all microservices.

<br>

```dotenv
BROKER_URL=
```

Same as `AUTH_DB_URL`, but for **RabbitMQ** message broker.
Skip this setting in the core microservice.
In other microservices set it to the core microservice broker url.

<br>

```dotenv
DJANGO_WEB_PORT=
```

Which http port should be exposed for entire service?
By default, `8000` port is used.
But if you're running multiple services on the same machine, you have to change it to another port.


---
## RabbitMQ

```dotenv
RABBITMQ_PORT=
```

Which port should be exposed for **RabbitMQ** that built in the `docker-compose.yml` file?
Default value is `5672`.

<br>

```dotenv
RABBITMQ_MANAGEMENT_PORT=
```

Which port should be exposed for **RabbitMQ** management that built in the `docker-compose.yml` file?
Default value is `15672`.

<br>

```dotenv
RABBITMQ_DEFAULT_USER=
```

Default username is `rabbitmq`.

<br>

```dotenv
RABBITMQ_DEFAULT_PASS=
```

Default password is `rabbitmq`.


---
### Sentry

```dotenv
SENTRY_DSN=
```

Your **Sentry** `DSN`. You can get it from your **Sentry** project settings.

<br>

```dotenv
SENTRY_ENVIRONMENT=
```

Default value is `development`.

