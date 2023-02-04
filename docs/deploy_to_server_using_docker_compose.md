# Deploy to server


---
## Prerequisites
I assume, you have docker with compose plugin installed on your server.
Please, refer to the [official documentation](https://docs.docker.com/engine/install/) to install it.

Clone the repository to your server:
```shell
git clone https://github.com/dj-ms/dj-ms-core.git
```

Go to the project directory:
```shell
cd dj-ms-core
```

Copy the `.example.env` file to `.env`:
```shell
cp .example.env .env
```

Edit the `.env` file and set the environment variables.
```shell
nano .env
```


---
## Run project
Build the docker image:
```shell
docker compose build
```

Run project:
```shell
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

> As you can see, we use two docker compose files: `docker-compose.yml` and `docker-compose.prod.yml`.
And that's all the difference between running locally and running in production.
So you can use all the commands you used to run locally. Just add `-f docker-compose.yml -f docker-compose.prod.yml` to them.


## Set up Nginx

### Install Nginx

Ubuntu:
```shell
sudo apt install nginx -y
```

CentOS:
```shell
sudo yum install nginx -y
```

### Configure Nginx

Create a new file in the `/etc/nginx/sites-available` directory:
```shell
sudo nano /etc/nginx/sites-available/your-domain-name.com
```

Paste the following content to the file:
```nginx
server {
    listen 80;
    server_name your-domain-name.com www.your-domain-name.com;

    location / {
        proxy_pass http://localhost:<DJANGO_WEB_PORT>; # Skip <DJANGO_WEB_PORT> if you didn't set it.
    }
}
```

Create a symbolic link to the `/etc/nginx/sites-enabled` directory:
```shell
sudo ln -s /etc/nginx/sites-available/your-domain-name.com /etc/nginx/sites-enabled/
```

Remove the default configuration file:
```shell
sudo rm /etc/nginx/sites-enabled/default
```

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

Check, that your domain name is accessible from the internet:
```shell
curl -I https://your-domain-name.com
```

Sometimes you need to wait some time, until your domain name will be accessible from the internet. Maybe 5 minutes or more.

### Install certbot

Ubuntu:
```shell
sudo apt install python3-certbot-nginx -y
```

CentOS:
```shell
sudo yum install python3-certbot-nginx -y
```

### Get SSL certificate

```shell
sudo certbot --nginx -d your-domain-name.com -d www.your-domain-name.com
```

You will be asked to enter your email address and agree with the terms of service.
After that, you will be asked to choose the redirect method. Choose the second option.

### Check SSL certificate

Open the following URL in your browser:
```shell
https://your-domain-name.com/<DJANGO_URL_PREFIX>/admin/ # Skip <DJANGO_URL_PREFIX> if you didn't set it.
```

If you see the Django admin page, then everything is fine.

### Configure automatic renewal of SSL certificate

```shell
sudo crontab -e
```

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
  /etc/letsencrypt/live/your-domain-name.com/fullchain.pem (success)
```

