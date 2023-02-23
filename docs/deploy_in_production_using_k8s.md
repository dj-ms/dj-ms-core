# Deploy to production using Kubernetes


---
## Postgres

```shell
kubectl apply -f k8s/postgres -n dj-ms-core
```


---
## RabbitMQ
```shell
kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"
```

```shell
kubectl apply -f k8s/rabbitmq -n dj-ms-core
```


---
## Django
```shell
kubectl create secret generic dj-ms-core-secret --from-env-file=k8s/app/.env -n dj-ms-core
kubectl apply -f k8s/app
```
