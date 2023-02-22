# Deploy to production using Kubernetes


```shell
kubectl apply -f k8s/postgres
```



```shell
kubectl create secret generic dj-ms-core-secret --from-env-file=k8s/app/.env -n dj-ms-core
kubectl apply -f k8s/app
```
