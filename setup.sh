#!/bin/bash

echo "installing Apache server"

sudo apt update
sudo apt install apache2 -y
sudo apt install php php-mysql libapache2-mod-php php-cli -y

sudo ufw allow in "Apache Full"

sudo chmod -R 0755 /var/www/html/

sudo systemctl enable apache2

sudo systemctl start apache2

sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php
