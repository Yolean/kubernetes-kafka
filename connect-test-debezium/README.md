### Testing kafka-connect in a kubernetes context

This `connect-debezium-test` feature branch is an attempt to get this demonstration [blog post](http://debezium.io/blog/2017/09/25/streaming-to-another-database/) from debezium running.  Debezium are behind a number of source connectors that facilitate change-data-capture from mySQL and postgres.  The also have a source connector for mongodb.

This particular demo uses the mySQL source connector and combines with the Confluent [kafka-connect-jdbc](https://github.com/confluentinc/kafka-connect-jdbc) sink connector in order to replicate changes from the mySQL database to the postgres database via a kafka message bus.