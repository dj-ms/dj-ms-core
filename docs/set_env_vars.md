# Set environment variables


> #### Note: you don't need to set all of these variables. docker compose files already have default values for most of them. But in production you have to set at least `DJANGO_SECRET_KEY`.

> Also, when running / deploying microservices, there is some requirements:
> 
> - use exact the same `DJANGO_SECRET_KEY` for all microservices;
> - all services except `core` needs to have `AUTH_DB_URL` set to `core` service's `DATABASE_URL`;
> - all services except `core` needs to have `BROKER_URL` set to `core` service's `BROKER_URL`.
> 
> other requirements will be explained below.

---
## Django

```dotenv
DJANGO_DEBUG=
```

In production, `DJANGO_DEBUG` is set to `False` in the `docker-compose.prod.yml` file.
In other cases default value will be `True` if not set.
You don't need to set it here unless you want to change it to `False` in _development environment_.

```dotenv
DJANGO_SECRET_KEY=
```

Use 1 strict secret key for all microservices.
You can generate one using one of these commands:
- `openssl rand -base64 40`
- `openssl rand -hex 40`
- `python -c 'import uuid; print(uuid.uuid4().hex)'`

```dotenv
DJANGO_TIME_ZONE=
```

Default timezone is `UTC`. You can change it to your local timezone. For example: `Europe/Warsaw`

```dotenv
DJANGO_LANGUAGE_CODE=
```

Default language is English (`en-us`). You can change it to your local language. For example: `ru`

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

---
### Postgres

```dotenv
POSTGRES_PORT=
```

Which port should be exposed for postgres that built in the `docker-compose.yml` file?
Default value is `5432`.

```dotenv
POSTGRES_USER=
```

Default postgres username is `postgres`.

```dotenv
POSTGRES_PASSWORD=
```

```dotenv
POSTGRES_DB=
```


---
### PGAdmin

```dotenv
PGADMIN_PORT=
```

```dotenv
PGADMIN_DEFAULT_EMAIL=
```

```dotenv
PGADMIN_DEFAULT_PASSWORD=
```


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


---
## RabbitMQ

```dotenv
RABBITMQ_PORT=
```

```dotenv
RABBITMQ_MANAGEMENT_PORT=
```

```dotenv
RABBITMQ_DEFAULT_USER=
```

```dotenv
RABBITMQ_DEFAULT_PASS=
```


---
## Nginx


---
### Sentry

```dotenv
SENTRY_DSN=
```

```dotenv
SENTRY_ENVIRONMENT=
```
