
# List topics
kubectl exec testclient -- ./bin/kafka-topics.sh --zookeeper zookeeper:2181 --list

# Create topic
kubectl exec testclient -- ./bin/kafka-topics.sh --zookeeper zookeeper:2181 --topic test1 --create --partitions 1 --replication-factor 1

# Set one of your terminals to listen to messages on the test topic
kubectl exec -ti testclient -- ./bin/kafka-console-consumer.sh --zookeeper zookeeper:2181 --topic test1 --from-beginning

# Go ahead and produce messages
echo "Write a message followed by enter, exit using Ctrl+C"
kubectl exec -ti testclient -- ./bin/kafka-console-producer.sh --broker-list kafka-0.broker.kafka.svc.cluster.local:9092 --topic test1

# Bootstrap even if two nodes are down (shorter name requires same namespace)
kubectl exec -ti testclient -- ./bin/kafka-console-producer.sh --broker-list kafka-0.broker:9092,kafka-1.broker:9092,kafka-2.broker:9092 --topic test1

# The following commands run in the pod
kubectl exec -ti testclient -- /bin/bash

# Topic 2, replicated
./bin/kafka-topics.sh --zookeeper zookeeper:2181 --describe --topic test2

./bin/kafka-verifiable-consumer.sh \
  --broker-list=kafka-0.broker.kafka.svc.cluster.local:9092,kafka-1.broker.kafka.svc.cluster.local:9092 \
  --topic=test2 --group-id=A --verbose

# If a topic isn't available this producer will tell you
# WARN Error while fetching metadata with correlation id X : {topicname=LEADER_NOT_AVAILABLE}
# ... but with current config Kafka will auto-create the topic
./bin/kafka-verifiable-producer.sh \
  --broker-list=kafka-0.broker.kafka.svc.cluster.local:9092,kafka-1.broker.kafka.svc.cluster.local:9092 \
  --value-prefix=1 --topic=test2 \
  --acks=1 --throughput=1 --max-messages=10
