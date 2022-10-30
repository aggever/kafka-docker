# Lab 0: Docker, Kafka and CLI

This is a Simple lab to get started with Docker and Kafka.

## Prerequesites
Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/).

Clone this repository.



Execute the `run.sh` script:
```
./run.sh
```

You can use the `docker ps` command to verify both Kafka and Zookeeper are running.

## The Kafka CLI
The Kafka CLI is an interactive shell environment that provides command-line access for managing Kafka. Kafka CLI allows typing text commands that perform specific tasks within the Kafka environment.

There are two ways to use Kafka CLI in the dockerized Kafka environment:
* Execute an interactive docker terminal command that starts a Kafka shell (note the Kafka container is named `broker` in the `docker-compose.yml` file):
```
docker exec -it broker /bin/sh
```
From the Kafka shell, issue the Kafka CLI command, for example:
```
kafka-topics.sh --create ...
```

* Execute the Kafka CLI command directly from Docker, for example:
```
docker-compose exec broker kafka-topics --create ...
```

## Kafka CLI: Create topic
To create a Kafka topic from the Kafka shell:
```
kafka-topics.sh --create \
    --topic example_kafka_topic \
    --zookeeper zookeeper:2181 \
    --replication-factor 1 \
    --partitions 1
```

To create a Kafka topic from Docker:

```
docker-compose exec broker kafka-topics \
    --create \
    --topic example_kafka_topic \
    --bootstrap-server localhost:9092 \
    --replication-factor 1 \
    --partitions 1
```

Note that:
* The first command specified the `--zookeeper` argument with the Zookeeper  name and port; this is compatible for Kafka v2.1 or less.
* The second command specified the `--bootstrap-server` argument with the Kafka broker name and port; this is compatible for Kafka v2.2 or more.

The `--zookeeper` option is now deprecated and is removed as part of Kafka v3.

In both cases, the CLI responds with:
```
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic example_kafka_topic.
```

## Kafka CLI: List topics
To list all Kafka topics:

```
docker-compose exec broker kafka-topics \
    --list \
    --bootstrap-server localhost:9092
```

The CLI responds with:
```
__consumer_offsets
_confluent-command
_confluent-telemetry-metrics
_confluent_balancer_api_state
_confluent_balancer_broker_samples
_confluent_balancer_partition_samples
example_kafka_topic
```

## Kafka CLI: View topic details
Kafka exposes a command to view metadata about the topics in a Kafka cluster, such as the number of partitions and replicas:

```
docker-compose exec broker kafka-topics \
    --describe \
    --topic example_kafka_topic \
    --bootstrap-server localhost:9092
```
The CLI responds with:
```
Topic: example_kafka_topic	TopicId: HSBeVORcRD2DDbTjjmtx-A	PartitionCount: 1	ReplicationFactor: 1	Configs:
	Topic: example_kafka_topic	Partition: 0	Leader: 1	Replicas: 1	Isr: 1	Offline:
```
## Kafka CLI: Publish events to a topic
Kafka CLI console producer client emits new events to a Kafka topic:
```
docker-compose exec broker kafka-console-producer \
    --topic example_kafka_topic \
    --bootstrap-server localhost:9092
```
After running this command, a prompt will open. Type your messages and click enter to publish them to the Kafka topic. Each time you click to enter a new message is submitted.
```
Event 1
Event 2
Event 3
```
There are now 3 published events to the example_kafka_topic topic. Ctrl+C stops the producer client.

## Kafka CLI: View topic events
Kafka CLI console consumer client can be used to view the events stored in a Kafka topic:
```
docker-compose exec broker kafka-console-consumer \
    --topic example_kafka_topic \
    --from-beginning \
    --bootstrap-server localhost:9092
```
The CLI responds with:
```
Event 1
Event 2
Event 3
```

## Kafka CLI: Delete topic
To delete a Kafka topic:
```
docker-compose exec broker kafka-topics \
    --delete \
    --topic example_kafka_topic \
    --bootstrap-server localhost:9092
```

## Destroy the environment

To destroy the environment, do:
```
./destroy.sh
```
