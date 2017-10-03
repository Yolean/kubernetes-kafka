FROM debezium/connect:0.6

# Deploy PostgreSQL JDBC Driver
RUN cd /kafka/libs && curl -sO https://jdbc.postgresql.org/download/postgresql-42.1.4.jar

# Deploy Kafka Connect JDBC
ENV KAFKA_CONNECT_JDBC_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-jdbc
RUN mkdir $KAFKA_CONNECT_JDBC_DIR && cd $KAFKA_CONNECT_JDBC_DIR &&\
	curl -sO http://packages.confluent.io/maven/io/confluent/kafka-connect-jdbc/3.3.0/kafka-connect-jdbc-3.3.0.jar
