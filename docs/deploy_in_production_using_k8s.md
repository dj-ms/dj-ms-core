# Deploy to production using Kubernetes


> **Note:** This is just an example.
> Please, review all the files in the `k8s` directory before applying them to your cluster.


---
## Prerequisites

### Create a namespace

```shell
kubectl create namespace dj-ms-core
```

### Install and configure Postgres DB

```shell
kubectl apply -f k8s/postgres
```

### Install and configure RabbitMQ

```shell
kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"
```

```shell
kubectl apply -f k8s/rabbitmq
```


---
## Deploy

### Django

```shell
kubectl create secret generic dj-ms-core-secret --from-env-file=k8s/app/.env -n dj-ms-core
kubectl apply -f k8s/app -n dj-ms-core
```
