# Deploy to production using Kubernetes
  
> **Note:** This is just an example.  
> Please, review all the files in the `k8s` directory before applying them to your cluster.

---
## Prerequisites
  
> I assume that you have a Kubernetes cluster and `kubectl` installed.  
> Other things I will try to describe here.
  
Copy example files  
  
```shell
cp -r k8s/examples k8s/production
```
  
Create a namespace  
  
```shell
kubectl create namespace <namespace>
```
  
### PostgreSQL
  
If you don't have a PostgreSQL database, you can install it using the following commands:  
  
```shell
kubectl create namespace postgres
kubectl apply -f k8s/postgres -n postgres
```

You will need to create a database and a user for your application.  
  
Get pod name:  
  
```shell
kubectl get pods -n postgres
```

You should see something like this:  
  
```shell
NAME                       READY   STATUS    RESTARTS   AGE
postgres-bbb44c799-g7v9j   1/1     Running   0          2m
```

Then you can connect to the database:  
  
```shell
kubectl exec -it <pod-name> -n postgres -- psql -U postgres
```
  
Create a database:  
  
```sql
CREATE DATABASE <database-name>;
```
  
Create a user:  
  
```sql
CREATE USER <user-name> WITH ENCRYPTED PASSWORD '<password>';
```
  
Grant permissions:  
  
```sql
GRANT ALL PRIVILEGES ON DATABASE <database-name> TO <user-name>;
```
  
  
### RabbitMQ
  
If you don't have a RabbitMQ cluster, you can install it using the following commands:

```shell
kubectl create namespace rabbitmq
kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml" -n rabbitmq
kubectl apply -f k8s/rabbitmq -n rabbitmq
```
  
You will need to create a user for your application.
  
Get pod name:  
  
```shell
kubectl get pods -n rabbitmq
```
  
You should see something like this:  
  
```shell
NAME                       READY   STATUS    RESTARTS   AGE
rabbitmq-7c78d7f66b-n84jr  1/1     Running   0          2m
```
  
Create a user:  
  
```shell
kubectl exec -it <pod-name> -n rabbitmq -- rabbitmqctl add_user <user-name> <password>
```
  
Grant permissions:  
  
```shell
kubectl exec -it <pod-name> -n rabbitmq -- rabbitmqctl set_user_tags <user-name> administrator
kubectl exec -it <pod-name> -n rabbitmq -- rabbitmqctl set_permissions -p / <user-name> ".*" ".*" ".*"
```

  
---
## Deploy
  
First of all, you should review all the files in the `k8s/production` directory.  
Change the values as you need.  
  
After that, you should create an `.env` file in the `k8s/production/app` directory.  
It should contain the following variables:  
  - `DJANGO_DEBUG` - normally `False` for production
  - `DJANGO_SECRET_KEY` - some random string. You can generate one with `openssl rand -base64 32`
  - `DATABASE_URL` - default value is `postgres://postgres:postgres@postgres:5432/postgres`
  - `DJANGO_ALLOWED_HOSTS` - your domain name. For example, `app.dj-ms.dev`
  - `DJANGO_CSRF_TRUSTED_ORIGINS` - usually the same as `DJANGO_ALLOWED_HOSTS` but with `https://` prefix. For example, `https://app.dj-ms.dev`
  - `BROKER_URL` - default value is `amqp://guest:guest@rabbitmq:5672`
  
Then you can create a secret and deploy the application:  
  
```shell
kubectl create secret generic <my-app>-secret --from-env-file=k8s/production/app/.env -n <namespace>
kubectl apply -f k8s/production/app -n <namespace>
```

  