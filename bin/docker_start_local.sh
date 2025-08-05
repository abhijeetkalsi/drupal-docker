#!/bin/bash
# Run Local Docker Compose instance
#
# Usage:
#   ./start-docker-container.sh [container_name] [image_name] [additional_docker_run_options]
#
# Arguments:
#   container_name                Name to assign to the Docker container.
#   image_name                    Docker image to use for the container.
#   additional_docker_run_options Optional. Any additional options to pass to 'docker run'.
#
# The script checks if Docker is installed and running, then starts the container with the given parameters.

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
