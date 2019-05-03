# Manual de Usuario

En este apartado se indican los pasos necesarios para reproducir la práctica. Primero hay que clonar el repositorio de la práctica:

`git clone https://github.com/adritake/CC2-18-19.git`


Instalar si no se tiene el CLI de Azure y hacer `az login`. A continuación creamos la MV con OwnCloud, para ello, dentro del repositorio ejecutar `bash crearMVOwncloud.sh`. Probar que funciona correctamente accediendo a la IP de la MV desde un explorador pero no se debe tocar nada de la instalación de OwnCloud de momento.

Ejecutamos `bash InstallMariaDBDocker.sh` para lanzar un docker con *MariaDB* en *Azure*. Una vez lanzado guardamos la IP y ejecutamos el siguiente comando para ejecutar un bash en ese docker:

`az container exec --resource-group myResourceGroup --name ownCloudMV --exec-command "/bin/bash"`

En el bash ejecutamos `mysql -p` y nos pedirá una contraseña que en este caso es *password*. Si se lanza mysql correctamente escribimos`CREATE TABLE "ownclouddb"` para crear la base de datos de owncloud.

Para crear el docker de *LDAP*, ejecutar `bash InstallLDAPDocker.sh`, guardamos la IP y ejecutamos el siguiente comando que crea el usuario indicado en el archivo *user.ldif*:
`ldapadd -H ldap://<IP> -x -D 'cn=admin,dc=example,dc=org' -w admin -c -f user.ldif`

Cambiar la contraseña del usuario creado con:
`sudo ldappasswd -H ldap://<IP> -s password -W -D "cn=admin,dc=example,dc=org" -x "cn=adrian,dc=example,dc=org"`

Volvemos a acceder a la IP de *OwnCloud* para completar la instalación. Introducimos un nombre de usuario cualquiera y una contraseña para la cuenta de administrador. Seleccionamos la pestaña de MySQL/MariaDB y le indicamos el usuario *root* que es el que tiene MariaDB por defecto, la contraseña es la introducida en la variable de entorno cuando creamos el docker (en este caso *password*), la base de datos es la que creamos cuando accedimos al contenedor (*ownclouddb*). Por último introducimos la IP del docker de MariaDB y el puerto que usa que es el 3306 en el formato `<IP>:3306`.

Una vez dentro de *OwnCloud* accedemos al Market y descargamos la aplicación LDAP Integration la cual delega la gestión de usuarios a un servidor LDAP. Una vez instalada, vamos a ajustes > autentificación de usuario y allí introducimos los datos del servidor LDAP(hay que tener el docker de LDAP funcionando previamente). Introducimos la IP del docker de LDAP y el puerto usado, si se pulsa detectar puerto debería aparecer el puerto 389 también. Introducimos el DIT `cn=admin,dc=example,dc=org`. La contraseña por defecto es *admin* y la base DN es `dc=example,dc=org`. Si todo funciona correctamente, abajo debería aparecer un círculo verde e indicar que la configuración es correcta.
Es posible que haya que introducir en la pestaña de Atributos de Inicio de sesión lo siguiente:
`(&(|(uid=%uid)))`

Con esto ya está todo configurado y se debería de poder iniciar sesión con el usuario creado en LDAP y subir y almacenar archivos.
