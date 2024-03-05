#!/bin/bash

# Update the package manager
sudo apt update

# Install the WebServer NGINX
sudo apt install nginx -y

# Install PHP module for NGINX
sudo apt install php8.1-fpm -y

# Remove the old default landing page symbolic link
sudo rm /etc/nginx/sites-enabled/default

# Create NGINX configuration file for CloudBuild website
sudo touch /etc/nginx/sites-available/cloudbuild

# Add symbolic link for new website
sudo ln -s /etc/nginx/sites-available/cloudbuild /etc/nginx/sites-enabled

# Append new configuration to CloudBuild NGINX config
sudo echo <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;

    index index.php index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF >> /etc/nginx/sites-available/cloudbuild

# Remove old website files
sudo rm -r /var/www/html/*

# Create new CRUD index file.
sudo echo <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>DB CRUD TEST</title>
</head>
<body>
<?php print("Hello World!"); ?>
</body>
</html>
EOF > /var/www/html/index.php

# Restart NGINX to apply config
sudo systemctl restart nginx