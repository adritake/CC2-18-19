#!/bin/bash

# Variables
RGNAME="myResourceGroup"
MVNAME="ownCloudMV"
SCRIPT="InstallOwnCloudDocker.sh"

# Creamos el grupo de recursos
az group create --location westeurope --name $RGNAME

# Creamos la MV con ubuntu
az vm create \
    --resource-group $RGNAME \
    --name $MVNAME \
    --image UbuntuLTS \
    --admin-username adritake \
    --generate-ssh-keys \
    --size Standard_A0 \
    --custom-data $SCRIPT

# Abrimos el puerto 80
az vm open-port --resource-group $RGNAME --name $MVNAME --port 80 --priority 900
