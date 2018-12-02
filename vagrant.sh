#!/usr/bin/env bash

# Add repository for PHP (5.6 || 7.0 || 7.2)
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

# Installing MySQL and it's dependencies, Also, setting up root password for MySQL as it will prompt to enter the password during installation
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password pass123'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password pass123'
apt-get -y install mysql-server libapache2-mod-auth-mysql

# Installing PHP and it's dependencies
# PHP 5.5 (this is the default and don't need ppa:ondrej/php)
# apt-get -y install php5 libapache2-mod-php5 php5-mcrypt curl php5-curl php5-mysql
# PHP 5.6 (from ppa:ondrej/php)
# apt-get -y install php5.6 libapache2-mod-php5.6 php5.6-mcrypt curl php5.6-curl php5.6-mysql
# PHP 7.0 (from ppa:ondrej/php)
# apt-get -y install php7.2 libapache2-mod-php7.2 php7.2-mcrypt curl php7.2-curl php7.2-gd php7.2-intl php7.2-mysql php7.2-mbstring php7.2-xml php7.2-zip
# PHP 7.2 (from ppa:ondrej/php)
apt-get install -y php7.2 php7.2-curl php7.2-gd php7.2-mbstring php7.2-zip php7.2-xml php7.2-mysql php7.2-intl

# Configure PHP
sed -i s/'display_errors = Off'/'display_errors = On'/ /etc/php/7.2/apache2/php.ini

# Download and configure 'adminer.php' to manage the MySQL database
if [ ! -f /usr/share/adminer.php ]; then
    wget -q -O adminer.php https://github.com/vrana/adminer/releases/download/v4.7.0/adminer-4.7.0-mysql.php
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