#!/bin/bash

if [ "$#" -lt 3 ]; then
  echo "Uso crearMV <nombre grupo> <nombre máquina> <script de provisión>"
  exit 1
fi

az group create --location westeurope --name $1

# Para cada una de las IPs que tenemos asignadas:

az vm create \
    --resource-group $1 \
    --name $2 \
    --image UbuntuLTS \
    --admin-username adritake \
    --generate-ssh-keys \
    --size Standard_A0 \
  #  --custom-data $3


az vm open-port --resource-group $1 --name $2 --port 80 --priority 900

az vm open-port --resource-group $1 --name $2 --port 3306 --priority 800
