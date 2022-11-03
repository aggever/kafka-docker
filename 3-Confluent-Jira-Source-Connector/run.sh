#!/bin/bash

docker compose -f docker-compose.yml up -d
docker-compose -f docker-compose-jira.yml up -d

docker-compose exec broker kafka-topics \
    --create \
    --topic jira_topic \
    --bootstrap-server localhost:9092 \
    --replication-factor 1 \
    --partitions 1 \
     --if-not-exists

exit 0
