# Django microservice core


![GitHub release (latest by date)](https://img.shields.io/github/v/release/dj-ms/dj-ms-core?display_name=release&style=for-the-badge)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/dj-ms/dj-ms-core?style=for-the-badge)
![GitHub issues](https://img.shields.io/github/issues/dj-ms/dj-ms-core?style=for-the-badge)
![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/dj-ms/dj-ms-core?style=for-the-badge)
![GitHub repo size](https://img.shields.io/github/repo-size/dj-ms/dj-ms-core?style=for-the-badge)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/harleyking/dj-ms-core?style=for-the-badge)

---


### This project helps to develop microservices with Django Framework. No more hundreds of apps in one project. Split every app into separate project. That helps to develop more flexible and scalable projects.


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


## Features
- [x] Expiring token authentication
- [x] Custom user model
- [x] Custom db router for auth models
- [x] Static and media files served by Nginx
- [ ] Message brokers integration
- [ ] Kubernetes integration
- [ ] Full documentation
- [ ] Email confirmation
- [ ] Active directory authentication
- [ ] Cloud storage integration
- [ ] Centralized logging
- [ ] Centralized monitoring
- [ ] Automatic discovery of microservices

---


## Requirements
- [Docker with docker compose](https://docs.docker.com/compose/install/)

---


## Installation

### [Run locally using docker compose](docs/run_locally_using_docker_compose.md)

### [Deploy to server using docker compose](docs/deploy_to_server_using_docker_compose.md)

---


## Examples
You can find example microservice app under [forks](https://github.com/dj-ms/dj-ms-core/network/members) section.
Also, there is an example microservice app: [dj-ms-example-app](https://github.com/dj-ms/dj-ms-example-app).

