az container create --resource-group myResourceGroup \
                    --dns-name-label dockermariadb \
                    --name dockermariadb \
                    --image mariadb:latest \
                    --ports 3306 \
                    --environment-variables MYSQL_ROOT_PASSWORD=password
