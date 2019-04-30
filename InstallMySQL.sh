#!/bin/bash

sudo apt-get update
sudo apt-get install mysql-server
sudo mysql_secure_installation
sudo ufw allow mysql
sudo ufw enable
sudo systemctl start mysql
sudo systemctl enable mysql
