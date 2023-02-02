Build project once
```shell
$ docker compose build
```

Run project
```shell
$ docker compose up -d
```

> Note: when running locally, you don't need to build project everytime after changing code 
> while you're not changing `requirements.txt`. 
> It's because local code is mounted into container so your changes are reflected immediately.

Enter container
```shell
$ docker compose exec app bash
```

Create superuser
```shell
$ python manage.py createsuperuser
```

View logs
```shell
$ docker compose logs -f
```
