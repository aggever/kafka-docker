# Introduction

This project provides connector for Kafka Connect to read data from Jira.

# Documentation

Documentation on the connector is hosted on Confluent's
[docs site](https://docs.confluent.io/current/connect/kafka-connect-jira/).

Source code is located in Confluent's
[docs repo](https://github.com/confluentinc/docs/tree/master/connect/kafka-connect-jira). If changes
are made to configuration options for the connector, be sure to generate the RST docs (as described
below) and open a PR against the docs repo to publish those changes!

# Configs

Documentation on the configurations for each connector can be automatically generated via Maven.

To generate documentation for the source connector:
```bash
mvn -Pdocs exec:java@source-config-docs
```

# Compatibility:

This connector has been tested against the Confluent Platform and supports compatibility with
 versions 5.3.x.

# Integration Tests

To run ITs in your local environment, please export the "JIRA_CREDENTIALS_PATH" environment variable to
the path of your credentials file, which must be in a JSON format.
```bash
export JIRA_CREDENTIALS_PATH=path/to/your/creds.json
```

An example credentials file:
```$xslt
{
  "creds": {
	"JIRA_USERNAME": <jira_username>,
	"JIRA_API_TOKEN": <jira_api_token>,
	"JIRA_SERVER": "<jira_base_url>",
	"JIRA_ACCOUNT_ID": "<lead_account_id>"
  }
}
```

You can run `vault kv get v1/ci/kv/connect/jira_it` to obtain JIRA credentials that
can be used to populate a credentials file.
