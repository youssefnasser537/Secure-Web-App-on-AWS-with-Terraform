#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

#  Disable the default welcome page
sudo mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.bak

# Add custom content
echo "<h1>Hello from Backend $(hostname)</h1>" | sudo tee /var/www/html/index.html

# Restart Apache to apply changes
sudo systemctl restart httpd
