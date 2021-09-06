Vagrant LAMP
============
A simple Vagrant LAMP for development (Ubuntu 20.04 LTS (Focal Fossa), Apache 2, PHP 7.4, MySQL 8.0)

Prerequisites
-------------
- [VirtualBox](https://www.virtualbox.org/) - Free  and open-source tool for virtual machines.
- [Vagrant](https://www.vagrantup.com/) - Free and open-source tool that automates the creation of development environments within a virtual machine.

Usage
-----
- Clone this repository or copy 'Vagrantfile' & 'vagrant.sh' files into your project folder
- Run `vagrant up`

Important info
--------------
- URL: `http://localhost:4000`
- MySQL: `http://localhost:4000/adminer` (username: root, password: pass123)
- Synced folder: `vagrant ssh` & `cd /vagrant`

Optional applications
---------------------
- phpMyAdmin: SSH into the running VM using `vagrant ssh` and run `sudo apt install phpmyadmin`. MySQL password for root is: pass123

Enjoy!
