#!/bin/bash
# Run Local Docker Compose instance

echo -e '\e[1;33m\nRunning Drupal Docker Container ...!\e[0m'

echo -e '\nSetting Environment variables...'

#printenv

# Validate Docker Compose file (For testing only)
#docker-compose -f ../docker-compose.yml config $*

echo -e '\nLoading Docker image...'

# Load and Run Container and image
docker-compose -f ../docker-compose.yml up -d $*

#Build project services. 
#docker-compose -f ../docker-compose.yml up --build $*

# To verify Domain is reachable in Container.
#curl -H Host:localhost.drupal.docker.com http://127.0.0.1:80 $*

$SHELL
