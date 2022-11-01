# Lab 3: Confluent Kafka REST Proxy

The Kafka REST Proxy provides a RESTful interface to a Kafka cluster, making it easy for HTTP-connected applications to produce and consume messages without needing to use Kafka clients.

The Kafka REST Proxy allows interaction with a Kafka cluster via a REST API over HTTP/HTTPS. It makes it easy to produce and consume messages, view the state of the cluster, and perform administrative actions without using the native Kafka protocol or clients. Clients can make simple, secure HTTP/HTTPS calls to the Kafka cluster, instead of relying on Kafka libraries. This lab demonstrates how to use the REST proxy to add records to a Kafka topic.

The Kafka REST Proxy is [open source](https://github.com/confluentinc/kafka-rest).

A disadvantage of the Kafka REST Proxy is the performance penalty due to the extra processing steps involved to transform data between different formats. Published benchmarks suggest that the Kafka REST Proxy performs at 67% of write throughput and 50% of read throughput compared to standard clients. For use cases with mission-critical workloads and demanding performance requirements, it is better to go with a Kafka client if possible.

For an alternative to Confluent REST Proxy, see the [Strimzi Kafka Bridge](https://github.com/strimzi/strimzi-kafka-bridge).

This lab realizes the [Getting Started with Apache Kafka and Confluent REST Proxy](https://developer.confluent.io/get-started/rest/#introduction) tutorial.

References:
* [Confluent REST APIs](https://docs.confluent.io/platform/current/kafka-rest/index.html#features)
* [Use Cases and Architectures for HTTP and REST APIs with Apache Kafka](https://www.confluent.io/blog/http-and-rest-api-use-cases-and-architecture-with-apache-kafka/)
* [Confluent REST Proxy API Reference](https://docs.confluent.io/platform/current/kafka-rest/api.html)

## Prerequesites
`jq` command-line JSON processor is required to execute the tests. [Download it from here](https://stedolan.github.io/jq/).

## Setup the environment

To setup the environment, do:
```bash
./run.sh
```

## Run the producer code
Run `./produce.sh`.

The script is based on the Confluent [produce.sh](https://github.com/confluentinc/examples/blob/7.2.2-post/clients/cloud/rest-proxy/produce.sh) example. See also: [REST Proxy: Example for Apache Kafka®](https://docs.confluent.io/platform/current/tutorials/examples/clients/docs/rest-proxy.html#crest-example-for-ak-tm).

The script steps are explained below.

### Get the Kafka cluster ID (API v3)
Get the Kafka cluster ID that the REST Proxy is connected to, using `jq`:
```bash
KAFKA_CLUSTER_ID=$(curl --silent -X GET "http://localhost:8082/v3/clusters/" | jq -r ".data[0].cluster_id")
echo $KAFKA_CLUSTER_ID
```

### Create topic (API v3)
Create a `rest_topic`:
```json
curl -sS -X POST \
     -H "Content-Type: application/json" \
     --data '{"topic_name":"rest_topic","partitions_count":1,"configs":[]}' \
     "http://localhost:8082/v3/clusters/${KAFKA_CLUSTER_ID}/topics" \
     | jq .
```

### Produce messages using JSON (API v2)
Post JSON data to `rest_topic`:
```json
curl -sS -X POST \
     -H "Content-Type: application/vnd.kafka.json.v2+json" \
     -H "Accept: application/vnd.kafka.json.v2+json" \
     --data '{"records":[{"key":"jsmith","value":"alarm clock"},{"key":"htanaka","value":"batteries"},{"key":"awalther","value":"bookshelves"}]}' \
     "http://localhost:8082/topics/rest_topic" \
     | jq .
```

## Run the consumer code
Run `./consume.sh`.

The script is based on the Confluent [consume.sh](https://github.com/confluentinc/examples/blob/7.2.2-post/clients/cloud/rest-proxy/consume.sh) example. See also: [REST Proxy: Example for Apache Kafka®](https://docs.confluent.io/platform/current/tutorials/examples/clients/docs/rest-proxy.html#consume-records).

The script steps are explained below.

### Create a consumer (API v2)
Create a new `rest_consumer` consumer instance in the `rest_consumer_group` consumer group:
```json
curl -sS -X POST \
     -H "Content-Type: application/vnd.kafka.v2+json" \
     --data '{"name":"rest_consumer","format":"json", "auto.offset.reset":"earliest","auto.commit.enable":"false"}' \
     "http://localhost:8082/consumers/rest_consumer_group" \
     | jq .
```

### Create a subscription (API v2)
Subscribe the consumer to the `rest_topic`:
```json
curl -sS -X POST \
     -H "Content-Type: application/vnd.kafka.v2+json" \
     --data '{"topics":["rest_topic"]}' \
     "http://localhost:8082/consumers/rest_consumer_group/instances/rest_consumer/subscription" \
     | jq .
```

### Verify scubscription (API v2)
Get the consumer current subscribed list of topics.
```json
curl -sS -X GET \
     -H "Accept: application/vnd.kafka.json.v2+json" \
     "http://localhost:8082/consumers/rest_consumer_group/instances/rest_consumer/subscription" \
     | jq .
```

### Consume records (API v2)
Fetch data for from the `rest_topic`:
```json
curl -sS -X GET \
     -H "Accept: application/vnd.kafka.json.v2+json" \
     "http://localhost:8082/consumers/rest_consumer_group/instances/rest_consumer/records?timeout=3000&max_bytes=300000" \
     | jq .
```

The curl command is issued twice, sleeping 10 seconds in between. This is intentional.

### Delete consumer (API v2)
Delete the consumer instance to clean up its resources:
```json
curl -sS -X DELETE \
     -H "Content-Type: application/vnd.kafka.json.v2+json" \
     "http://localhost:8082/consumers/rest_consumer_group/instances/rest_consumer" \
     | jq .
```

## Destroy the environment

To destroy the environment, do:
```bash
./destroy.sh
```
