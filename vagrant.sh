#!/usr/bin/env bash

# Add repository for PHP (7.2)
add-apt-repository ppa:ondrej/php

# Update the list of available packages
apt-get -y update

# Install GIT
apt-get install -y git

# Installing Apache
apt-get install -y apache2

# Remove 'html' folder and add a symbolic link, only if it doesn't already exists
if ! [ -L /var/www/html ]; then
  rm -rf /var/www/html
  ln -fs /vagrant /var/www/html
fi

# Change AllowOverride in apache2.conf for the .htaccess to work
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
# Enable Apache's mod_rewrite
sudo a2enmod rewrite

# Install MySQL Server in a Non-Interactive mode. Default root password will be "pass123"
echo "mysql-server-5.7 mysql-server/root_password password pass123" | sudo debconf-set-selections
echo "mysql-server-5.7 mysql-server/root_password_again password pass123" | sudo debconf-set-selections
apt-get install mysql-server -y

# Change MySQL Listening IP Address from local 127.0.0.1 to All IPs 0.0.0.0
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

# Update mysql Table root record to accept incoming remote connections
mysql -uroot -proot -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'

# Restart MySQL Service
service mysql restart

# Installing PHP and it's dependencies
apt-get -y install php7.2 libapache2-mod-php7.2 curl php7.2-curl php7.2-gd php7.2-mysql php7.2-mbstring php7.2-xml php7.2-zip php7.2-intl

# Configure PHP
sed -i s/'display_errors = Off'/'display_errors = On'/ /etc/php/7.2/apache2/php.ini

# Download and configure 'adminer.php' to manage the MySQL database
if [ ! -f /usr/share/adminer.php ]; then
    wget -q -O adminer.php https://github.com/vrana/adminer/releases/download/v4.7.1/adminer-4.7.1-mysql.php
    mv adminer.php /usr/share/adminer.php
    
    # Create an alias for adminer, example: http://localhost:4000/adminer 
    echo "alias /adminer '/usr/share/adminer.php'" >> /etc/apache2/sites-available/000-default.conf
fi

# Install Composer
if [ ! -f /usr/local/bin/composer ]; then
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
fi

# Restart Apache
service apache2 restart

# Add an alias for codecept
echo "alias codecept='php /vagrant/vendor/bin/codecept'" >> /home/vagrant/.bashrc

echo "============================================"
echo "Your development LAMP stack is ready"
echo "URL: http://localhost:4000"
echo "MySQL: http://localhost:4000/adminer (username: root, password: pass123)"
echo "Synced folder: 'vagrant ssh' & 'cd /vagrant'"
echo "============================================"