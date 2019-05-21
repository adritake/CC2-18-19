az container create --resource-group myResourceGroup \
                    --dns-name-label dockerldap \
                    --name dockerldap \
                    --image osixia/openldap:1.2.4 \
                    --ports 389 636
