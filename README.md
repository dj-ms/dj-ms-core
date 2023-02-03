# Django microservice core

> ## Still in development.
> ### Not ready for production.
> #### Will be ready for production with version 1.0.0


> First of all this is simple Django project with some customizations.
If you are newbie in Django, you can use this project as a template for your own projects.
I'm not very cool in programming, but I have some experience in Python and Django and want to share it with you.


## Purpose
This project helps to develop microservices in Django.
No more hundreds of apps in one project. Split every app into separate project.
That helps to develop more flexible and scalable projects.


## How it works
<p align="center">
  <img src="docs/media/scheme.png" alt="How it works" align="center" width="400px">
</p>


## Features
- [x] Django
- [x] Django REST framework
- [x] Websockets with Django channels
- [x] Docker
- [x] Docker compose for development & production
- [x] Celery & Celery beat
- [x] Redis
- [x] PostgreSQL & PGAdmin
- [x] Nginx
- [x] Gunicorn
- [x] Custom db router for auth models
- [x] Deployment to VPS
- [x] Serving static and media files with Nginx
- [x] Sentry integration
- [ ] Expiring token authentication
- [ ] Custom user model
- [ ] Message brokers integration
- [ ] Kubernetes integration
- [ ] Automated CI/CD
- [ ] Automated tests
- [ ] Full documentation
- [ ] Email confirmation
- [ ] Social authentication
- [ ] Active directory authentication
- [ ] Cloud storage integration
- [ ] Deployment to Saas / PaaS / IaaS providers
- [ ] Centralized logging
- [ ] Centralized monitoring
- [ ] Automatic discovery of microservices
- [ ] Centralized admin panel


### [Run locally using docker compose](docs/run_locally_using_docker_compose.md)

### [Deploy to server using docker compose](docs/deploy_to_server_using_docker_compose.md)
