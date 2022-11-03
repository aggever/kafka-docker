## Purpose
This repository contains docker compose templates that will create a Kafka environment in Docker.

The purpose of this repository is test and demonstrate the use of Kafka for integration of applications, such as Jira-to-Jira and forwarder-to-Splunk using Kafka.

## Labs
Currently the following labs are part of this repository:
* [Lab 0](./0-Kafka-Docker/) - setup a Kafka environment and demonstrate the use of basic Kafka CLI commands.
* [Lab 1](./1-Confluent-Platform-all-in-one/) - setup Confluent Platform and explore the Confluent Control Center via the browser.
* [Lab 2](./2-Confluent-REST-Proxy/) - setup Kafka REST Proxy and execute curl commands to Kafka broker.
* [Lab 3](./3-Confluent-Jira-Source-Connector/) - setup Kafka REST Proxy and execute curl commands to Kafka broker.
