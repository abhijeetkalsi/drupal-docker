# Drupal Docker Setup
 
 This setup provides a Docker-based environment for running and developing Drupal applications.

 Features:
 - Uses official Drupal and supporting service images (e.g., MySQL, PostgreSQL).
 - Supports local development with automatic file syncing and port mapping.
 - Easily configurable for different Drupal versions and database backends.
 - Includes recommended volumes for persistent storage of files and database data.
 - Example configuration for environment variables (database credentials, site settings).

## Usage:
 1. Copy the provided docker-compose.yml and .env.example files to your project root.
 2. Adjust environment variables as needed for your local setup.
 3. Run `docker-compose up -d` to start the containers.
 4. Access Drupal at http://localhost:8080 (or configured port).
 
 ## Customisation:
 - Add additional services (e.g., Redis, Solr) as needed.
 - Mount custom modules, themes, or configuration directories via Docker volumes.
 - Extend the Drupal image with a custom Dockerfile for additional PHP extensions or tools.
 
## Welcome to Drupal Docker - LAMP Stack Container - A Composer Project

* Build images and start your docker containers 
> `docker-compose up -d`
        
Later, once your containers are built : 
    * `docker-compose start` will start them
    * `docker-compose stop` will stop them


* Connect to your php container with :
> `docker-compose exec drupal bash`
  

### Composer Install

> `composer install`


**Environment Variable**


Please refer to example.env to how to work on environment variable using `.ENV` file

### DRUSH

> `vendor/bin/drush cache-rebuild`

If you are using a multi-site and let say the domain is my.example.com added in sites.php
> `vendor/bin/drush --uri=https://my.example.com cache-rebuild`


### Configuration Management

The power mechanism to move the database configuration as part of your Code Build

To extract all configuration from your working Drupal instance in your folder inside the working directory. Let say "./config/sync". Do not forget to add configuration YMLs to your repository
> `vendor/bin/drush config-export`
or
> `vendor/bin/drush cex`

The team will be able to update their local instance or update the Environment  container instance.
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
Directly run a shell script "docker-compose-build.sh" in bin/. This will install the PHP, MySQL, Memcached, Drupal, and Traefik containers in your local Docker container. Once this command is successfully set up. No need to run it again as this will be stored in the user's Docker container. 

> `shell/docker-compose-build.sh`

**Make your Container ready**

> `docker-compose -f docker-compose.yml up -d`


**Browse the browser**
Now you can access the site in the browser and type http://localhost/. Then all set up.
PHP My Admin http://localhost:8081/

**REFERENCES**

- https://www.drupal.org/docs/develop/using-composer/
