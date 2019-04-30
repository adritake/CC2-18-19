#!/bin/bash

sudo apt update

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge"

apt-cache policy docker-ce

sudo apt-get install -y docker-ce

docker --version

sudo ufw allow 80

sudo docker run -d -p 80:80 owncloud