## Run in production using docker compose


Set environment variables as explained in `.example.env` file.

Build project
```shell
docker compose build
```

Run project
```shell
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

> As you can see, we use two docker compose files: `docker-compose.yml` and `docker-compose.prod.yml`.
And that's all the difference between running locally and running in production.
So you can use all the commands you used to run locally. Just add `-f docker-compose.yml -f docker-compose.prod.yml` to them.

