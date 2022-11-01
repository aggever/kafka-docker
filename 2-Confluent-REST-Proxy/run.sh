#!/bin/bash

source ../scripts/colors.sh

# Avoid "Found orphan containers" warning
export COMPOSE_IGNORE_ORPHANS=True

docker compose up -d

echo -e "${Green}Waiting 5s for Kafka broker to start...${Color_Off}"
sleep 5

echo -e "${Green}Waiting 2s for 'rest_topic' to be created...${Color_Off}"
sleep 2

docker-compose -f rest-proxy.yml up -d

exit 0
