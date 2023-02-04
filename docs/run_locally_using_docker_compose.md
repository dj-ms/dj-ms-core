## Run locally using docker compose


Set environment variables as explained in `.example.env` file.

> Note: when running locally, you don't need to build project while unless you change `requirements.txt`. 
> It's because local code is mounted into container so your changes are reflected immediately.

Build project
```shell
docker compose build
```

Run project
```shell
docker compose up -d
```

Enter container
```shell
docker compose exec django bash
```

Create superuser
```shell
python manage.py createsuperuser
```

Now you can access admin panel at `http://localhost:8000/admin/`.

If you have set `DJANGO_URL_PREFIX` in `.env` file, 
then you should access admin panel at `http://localhost:8000/<DJANGO_URL_PREFIX>/admin/`.

View logs
```shell
docker compose logs -f
```

> Note: you can use `docker compose logs -f django` to view only django logs.

Stop project
```shell
docker compose down
```

## PGAdmin

On local environment, you can use PGAdmin to access database.

By default, PGAdmin is available at `http://localhost:5050/`.

But if you have set `PGADMIN_PORT` in `.env` file, 
then you should access PGAdmin at `http://localhost:<PGADMIN_PORT>/`.

Default credentials are `pgadmin4@pgadmin.org` and `admin`.
