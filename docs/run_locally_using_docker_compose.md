Run project
```shell
docker compose up -d
```

> Note: when running locally, you don't need to build project while you're not changing `requirements.txt`. 
> It's because local code is mounted into container so your changes are reflected immediately.

Build project
```shell
docker compose build
```

Enter container
```shell
docker compose exec django bash
```

Create superuser
```shell
python manage.py createsuperuser
```

View logs
```shell
docker compose logs -f
```
