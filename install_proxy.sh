#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx

# NGINX as reverse proxy
cat <<EOF | sudo tee /etc/nginx/nginx.conf
events {}
http {
  server {
    listen 80;
    location / {
      proxy_pass "${backend_url}";
    }
  }
}
EOF

sudo systemctl restart nginx
