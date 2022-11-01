#!/bin/bash
# Based on the Confluent produce.sh script (https://github.com/confluentinc/examples/blob/7.2.2-post/clients/cloud/rest-proxy/produce.sh)

source ../scripts/colors.sh

### Get the Kafka cluster ID (API v3)
echo -e "${Green}Getting Kafka cluster ID${Color_Off}"
KAFKA_CLUSTER_ID=$(curl --silent -X GET "http://localhost:8082/v3/clusters/" | jq -r ".data[0].cluster_id")
echo $KAFKA_CLUSTER_ID

### Create topic (API v3)
echo -e "${Green}Creating 'rest_topic'${Color_Off}"
curl -sS -X POST \
     -H "Content-Type: application/json" \
     --data '{"topic_name":"rest_topic","partitions_count":1,"configs":[]}' \
     "http://localhost:8082/v3/clusters/${KAFKA_CLUSTER_ID}/topics" \
     | jq .

### Produce messages using JSON (API v2)
echo -e "${Green}Producing 3 messages on 'rest_topic'${Color_Off}"
curl -sS -X POST \
     -H "Content-Type: application/vnd.kafka.json.v2+json" \
     -H "Accept: application/vnd.kafka.json.v2+json" \
     --data '{"records":[{"key":"jsmith","value":"alarm clock"},{"key":"htanaka","value":"batteries"},{"key":"awalther","value":"bookshelves"}]}' \
     "http://localhost:8082/topics/rest_topic" \
     | jq .
