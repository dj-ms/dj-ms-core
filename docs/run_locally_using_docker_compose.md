# Run locally using docker compose


---
## Prerequisites

Create the `.env` file and set the environment variables according to the instructions.
[Set environment variables](set_env_vars.md).
```shell
nano .env
```


---
## Run project
> Note: when running locally, you don't need to build project while unless you change `requirements.txt`. 
> It's because local code is mounted into container so your changes are reflected immediately.

Build
```shell
docker compose build
```


---
### Run

Core service:
```shell
docker compose -f docker-compose.yml -f docker-compose.core.yml -f docker-compose.override.yml up -d
```

<br>

Any microservice:
```shell
docker compose up -d
```

<br>

Enter container
```shell
docker compose exec django bash
```

<br>

Create superuser
```shell
python manage.py createsuperuser
```

<br>

View logs
```shell
docker compose logs -f
```

> Note: you can use `docker compose logs -f django` to view only django logs.

Stop project
```shell
docker compose down
```


---
## Access project
Now you can access admin panel at `http://localhost:8000/admin/`.

If you have set `DJANGO_URL_PREFIX` in `.env` file, 
then you should access admin panel at `http://localhost:8000/<DJANGO_URL_PREFIX>/admin/`.


---
## PGAdmin

On local environment, you can use PGAdmin to access database.

By default, PGAdmin is available at `http://localhost:5050/`.

But if you have set `PGADMIN_PORT` in `.env` file, 
then you should access PGAdmin at `http://localhost:<PGADMIN_PORT>/`.

Default credentials are `pgadmin4@pgadmin.org` and `admin`.
