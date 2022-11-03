# Lab 0: Run Confluent Platform all in one demo

Simple lab to get started with Docker, Kafka and the Confluent Platform.

First, download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/).

Clone this repository (which is a direct copy of [Confluent cp-all-in-one](https://github.com/confluentinc/cp-all-in-one/tree/7.2.2-post/cp-all-in-one))

Execute the `run.sh` script:
```
./run.sh
```

Open the Confluent Platform Control Center in you browser: [http://localhost:9021/](http://localhost:9021/)

You should see the following page in your browser:

![screenshot](../img/confluent-platform-home-screenshot.png)

You can also use the `docker ps` command to verify both are running.

Once Zookeeper and Kafka containers are running, you can execute the following Terminal command to start a Kafka shell (note the Kafka container is named `broker` in the `docker-compose.yml` file):
```
docker exec -it broker /bin/sh
```

To create a Kafka topic from the Kafka shell:
```
kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic example_kafka_topic
```

To create a Kafka topic without the Kafka shell:

```
docker-compose exec broker kafka-topics \
    --create \
    --topic example_kafka_topic \
    --bootstrap-server localhost:9092 \
    --replication-factor 1 \
    --partitions 1
```

To destroy the environment, do:
```
./destroy.sh
```
