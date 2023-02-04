# Deploy to production using Kubernetes


---
> To be honest, I don't know how to work with Kubernetes yet. But I'm just learning it at the moment. 
> The guide will be updated as I delve into the topic.


---
## Prerequisites
I assume that you have a Kubernetes cluster, and you can access it using `kubectl` command.

Also, you need some PostgreSQL database that you can access from your Kubernetes cluster.



---
## Deploy project
### Set environment variables
Copy the `.example.env` file to `.env`:
```shell
cp .example.env .env
```

Edit the `.env` file and set the environment variables:
```shell
nano .env
```

Create secret from `.env` file:
```shell
kubectl create secret generic dj-ms-core-secret --from-env-file=.env
```

Apply deployment and service:
```shell
kubectl apply -f kubernetes-deployment.yml
kubectl apply -f kubernetes-service.yml
```
