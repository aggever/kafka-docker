#!/bin/bash
# Based on the Confluent consume.sh script (https://github.com/confluentinc/examples/blob/7.2.2-post/clients/cloud/rest-proxy/consume.sh)

source ../scripts/colors.sh

### Create a consumer (API v2)
echo -e "${Green}Create a new 'rest_consumer' consumer instance in the 'rest_consumer_group' consumer group${Color_Off}"

curl -sS -X POST \
     -H "Content-Type: application/vnd.kafka.v2+json" \
     --data '{"name":"rest_consumer","format":"json", "auto.offset.reset":"earliest","auto.commit.enable":"false"}' \
     "http://localhost:8082/consumers/rest_consumer_group" \
     | jq .


### Create a subscription (API v2)
echo -e "${Green}Subscribe the consumer to the 'rest_topic':${Color_Off}"

curl -sS -X POST \
     -H "Content-Type: application/vnd.kafka.v2+json" \
     --data '{"topics":["rest_topic"]}' \
     "http://localhost:8082/consumers/rest_consumer_group/instances/rest_consumer/subscription" \
     | jq .


### Verify scubscription (API v2)
echo -e "${Green}Get the consumer current subscribed list of topics.${Color_Off}"

curl -sS -X GET \
     -H "Accept: application/vnd.kafka.json.v2+json" \
     "http://localhost:8082/consumers/rest_consumer_group/instances/rest_consumer/subscription" \
     | jq .


### Consume records (API v2)
echo -e "${Green}Fetch data for from the 'rest_topic':${Color_Off}"

curl -sS -X GET \
     -H "Accept: application/vnd.kafka.json.v2+json" \
     "http://localhost:8082/consumers/rest_consumer_group/instances/rest_consumer/records?timeout=3000&max_bytes=300000" \
     | jq .

echo -e "${Green}Sleeping 5 seconds...${Color_Off}"
sleep 5

echo -e "${Green}Repeat: Fetch data for from the 'rest_topic':${Color_Off}"

curl -sS -X GET \
     -H "Accept: application/vnd.kafka.json.v2+json" \
     "http://localhost:8082/consumers/rest_consumer_group/instances/rest_consumer/records?timeout=3000&max_bytes=300000" \
     | jq .

### Delete consumer (API v2)
echo -e "${Green}Deleting consumer instance:${Color_Off}"
curl -sS -X DELETE \
     -H "Content-Type: application/vnd.kafka.json.v2+json" \
     "http://localhost:8082/consumers/rest_consumer_group/instances/rest_consumer" \
     | jq .
