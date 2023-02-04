# Django microservice core


![GitHub release (latest by date)](https://img.shields.io/github/v/release/dj-ms/dj-ms-core?display_name=release&style=for-the-badge)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/dj-ms/dj-ms-core?style=for-the-badge)
![GitHub issues](https://img.shields.io/github/issues/dj-ms/dj-ms-core?style=for-the-badge)
![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/dj-ms/dj-ms-core?style=for-the-badge)
![GitHub repo size](https://img.shields.io/github/repo-size/dj-ms/dj-ms-core?style=for-the-badge)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/harleyking/dj-ms-core?style=for-the-badge)


---
<h3>
This project helps to develop microservices with Django Framework.

No more tens of apps in one project.
Separate your apps into microservices and connect them under one domain.
Every Django app can be developed and deployed separately, even by different teams.
But all of them will be under one domain and will have unified authentication.

</h3>


---
> #### Note: First of all this is simple Django project with some customizations. If you are newbie in Django, you can use this project as a template for your own projects. I'm not very cool in programming, but I have some experience in Python and Django and want to share it with you.


---
> #### Not ready for production. Will be ready with version 1.0.0


---
## How it works
<p align="center">
  <img src="docs/media/scheme.png" alt="How it works" align="center">
</p>


---
## What's inside
- [x] Unified authentication in all microservices
- [x] Docker compose both for local development and production
- [x] Celery, Celery Beat, Redis, Postgres, Nginx and PGAdmin included in docker compose
- [x] Kubernetes deployment
- [x] Expiring token authentication
- [x] Custom user model
- [x] Custom db router for auth models
- [x] Static and media files served by Nginx
- [x] Websocket support
- [ ] Automated CI/CD
- [ ] Active directory authentication
- [ ] Message brokers integration
- [ ] Automatic discovery of microservices

---


## Requirements
- [Docker with docker compose](https://docs.docker.com/compose/install/)

---


## Installation

### [Run locally using docker compose](docs/run_locally_using_docker_compose.md)

### [Deploy to server using docker compose](docs/deploy_to_server_using_docker_compose.md)

### [Deploy to production using Kubernetes](docs/deploy_in_production_using_k8s.md)

---


## Examples
You can find example microservice app under [forks](https://github.com/dj-ms/dj-ms-core/network/members) section.
Also, there is an example microservice app: [dj-ms-example-app](https://github.com/dj-ms/dj-ms-example-app).

