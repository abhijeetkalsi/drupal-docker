#!/bin/bash
# Run Local Docker Compose instance

echo -e '\e[1;33m\nRunning LifePoints - Local Docker Container ...!\e[0m'

echo -e '\nSetting LP Environment variables...'

export LP_PROJECT_NAME=lifepoints
export PLATONE_STAGE=alpha
export PLATONE_ENV=developer
export DB_SUFFIX=_local

#printenv

# Validate Docker Compose file (For testing only)
#docker-compose -f ../docker-compose.yml config $*

echo -e '\nLoading Docker LP image...'
# Load and Run Container and image
docker-compose -f ../docker-compose.yml up -d $*

#Build project services. 
#docker-compose -f ../docker-compose.yml up --build $*

# To verify Domain is reachable in Container.
#curl -H Host:local.lifepointspanel.com http://127.0.0.1:80 $*

$SHELL
