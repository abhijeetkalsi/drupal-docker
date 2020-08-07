### Welcome to Drupal Docker - LAMP Stack Container - A Composer Project

**Composer Install**

> `composer install`


**Environment Variable**


Please refer to example.env to how to work on environment variable using `.ENV` file

**DRUSH**

> `vendor/bin/drush cache-rebuild`

If you are using a multi-site and let say the domain is my.example.com added in sites.php
> `vendor/bin/drush --uri=https://my.example.com cache-rebuild`


### Configuration Management

The power mechanism to move database configuration as part of your Code Build

To extract all configuration from your working Drupal instance in your folder inside the working directory. Let say "./config/sync". Do not forget to add configuration YMLs in your repository
> `vendor/bin/drush config-export`
or
> `vendor/bin/drush cex`

The team will able to update there local instance or to update your Environment  container instance.
> `vendor/bin/drush config-import`
or
> `vendor/bin/drush cim`


**Drupal recommended Update**

> 'drupal/core-recommended --with-dependencies'
> 'drush updatedb'
> 'drush cache:rebuild'

### Docker Container

**Docker Compose Build**

`docker-compose -f docker-compose.yml up --build`
OR
Directly run a shell script "docker-compose-build.sh" in bin/. This will install the PHP, MySQL, Memcached, Drupal, Traefik containers in your local docker container. Once this command successfully setup. No need to run it again as this will store in the user docker container. 

> `shell/docker-compose-build.sh`

**Make your Container ready**

> `docker-compose -f docker-compose.yml up -d`


**Browse the browser**
Now you can access the site in the browser and type [](http://local.drupal.docker.com). Then all set up.

**Traefik Dashboard**
URL: (http://localhost:8080/)


**REFERENCES**

- https://www.drupal.org/docs/develop/using-composer/
