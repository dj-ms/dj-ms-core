# Deploy to server


---
## Prerequisites
I assume, you have docker with compose plugin installed on your server.
Please, refer to the [official documentation](https://docs.docker.com/engine/install/) to install it.

<br>

Clone the repository to your server:
```shell
git clone https://github.com/dj-ms/dj-ms-core.git
```

<br>

Go to the project directory:
```shell
cd dj-ms-core
```

<br>

Create the `.env` file and set the environment variables according to the instructions.
[Set environment variables](set_env_vars.md).
```shell
nano .env
```


---
## Run project
Build the docker image:
```shell
docker compose build
```

---
### Run:

Core service:
```shell
docker compose -f docker-compose.yml -f docker-compose.core.yml -f docker-compose.prod.yml up -d
```

<br>

Any microservice:
```shell
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

> As you can see, we use two docker compose files: `docker-compose.yml` and `docker-compose.prod.yml`.
And that's all the difference between running locally and running in production.
So you can use all the commands you used to run locally. Just add `-f docker-compose.yml -f docker-compose.prod.yml` to them.


> On master node you might need to open ports for DB and RabbitMQ. 
> Search solution in the internet, because it depends on your cloud provider, OS, etc.
> To open ports in VPS on Ubuntu, you can use the following commands:
> ```shell
> sudo ufw allow 5432/tcp
> sudo ufw allow 5672/tcp
> sudo ufw allow 15672/tcp
> sudo iptables -I INPUT -p tcp -m tcp --dport 5432 -j ACCEPT
> sudo iptables -I INPUT -p tcp -m tcp --dport 5672 -j ACCEPT
> sudo iptables -I INPUT -p tcp -m tcp --dport 15672 -j ACCEPT
> ```
> And then save the rules:
> ```shell
> sudo iptables-save > /etc/iptables/rules.v4
> ```
> This is not a final solution, but it works for me.

## Set up Nginx

### Install Nginx

Ubuntu:
```shell
sudo apt install nginx -y
```

<br>

CentOS:
```shell
sudo yum install nginx -y
```

### Configure Nginx

Create a new file in the `/etc/nginx/sites-available` directory:
```shell
sudo nano /etc/nginx/sites-available/<YOUR_DOMAIN_NAME>
```

<br>

Paste the following content to the file:
```nginx
server {
    listen 80;
    server_name <YOUR_DOMAIN_NAME> www.<YOUR_DOMAIN_NAME>;

    location / {
        proxy_pass http://localhost:<DJANGO_WEB_PORT>;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

<br>

Create a symbolic link to the `/etc/nginx/sites-enabled` directory:
```shell
sudo ln -s /etc/nginx/sites-available/<YOUR_DOMAIN_NAME> /etc/nginx/sites-enabled/
```

<br>

Remove the default configuration file:
```shell
sudo rm /etc/nginx/sites-enabled/default
```

<br>

Restart Nginx:
```shell
sudo systemctl restart nginx # or "nginx -s reload" to reload the configuration without restarting the service
```

### Check Nginx configuration

Open the following URL in your browser:
```shell
http://your-server-ip-address/<DJANGO_URL_PREFIX>/admin/ # Skip <DJANGO_URL_PREFIX> if you didn't set it.
```

If you see the Django admin page, then everything is fine.


## Configure HTTPS

First, get some domain name from any service, for example, from [namecheap](https://www.namecheap.com) or [freenom](https://www.freenom.com).
Create A-record for your domain name and point it to your server IP address.

<br>

Check, that your domain name is accessible from the internet:
```shell
curl -I http://<YOUR_DOMAIN_NAME>
```

<br>

> Sometimes you need to wait some time, until your domain name will be accessible from the internet. Maybe 5 minutes or more.

### Install certbot

Ubuntu:
```shell
sudo apt install python3-certbot-nginx -y
```

<br>

CentOS:
```shell
sudo yum install python3-certbot-nginx -y
```

### Get SSL certificate

```shell
sudo certbot --nginx -d <YOUR_DOMAIN_NAME> -d www.<YOUR_DOMAIN_NAME>
```

You will be asked to enter your email address and agree with the terms of service.
After that, you will be asked to choose the redirect method. Choose the second option.

### Check SSL certificate

Open the following URL in your browser:
```shell
https://<YOUR_DOMAIN_NAME>/<DJANGO_URL_PREFIX>/admin/ # Skip <DJANGO_URL_PREFIX> if you didn't set it.
```

If you see the Django admin page, then everything is fine.

### Configure automatic renewal of SSL certificate

```shell
sudo crontab -e
```

<br>

Add the following line to the end of the file:
```shell
0 0 * * * /usr/bin/certbot renew --quiet
```

Save the file and exit.

### Check automatic renewal of SSL certificate

```shell
sudo certbot renew --dry-run
```

If you see the following message, then everything is fine:
```shell
Congratulations, all renewals succeeded. The following certs have been renewed:
  /etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/fullchain.pem (success)
```

