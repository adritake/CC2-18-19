#!/bin/bash

# Actualizamos las aplicaciones
sudo apt update
# Agregamos la clave GPG para el repositorio oficial de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Agreamos el repositorio de docker a las fuentes de apt
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge"
# Nos aseguramos de que se instala desde el repositorio de docker en lugar del de ubuntu
apt-cache policy docker-ce
# Instalamos docker
sudo apt-get install -y docker-ce
# Permitimos en el cortafuegos de la MV el puerto 80 ya que es el que usa ownCloud
sudo ufw allow 80
# Activamos el cortafuegos
sudo ufw enable
# Lanzamos el docker de owncloud en el puerto 80
sudo docker run -d -p 80:80 owncloud
