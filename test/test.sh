
# Create topic
kubectl exec testclient -- ./bin/kafka-topics.sh --zookeeper zookeeper:2181 --topic test1 --create --partitions 1 --replication-factor 1

# Set one of your terminals to listen to messages on the test topic
kubectl exec -ti testclient -- ./bin/kafka-console-consumer.sh --zookeeper zookeeper:2181 --topic test1 --from-beginning

# Go ahead and produce topics, haven't found a way to do this directly through kubectl exec
kubectl exec -ti testclient -- /bin/bash
echo "Test $(date)" | ./bin/kafka-console-producer.sh --broker-list kafka-0.broker.kafka.svc.cluster.local:9092 --topic test1
echo "Test $(date)" | ./bin/kafka-console-producer.sh --broker-list kafka-1.broker:9092,kafka-2.broker:9092 --topic test1
# "WARN Removing server from bootstrap.servers as DNS resolution failed: kafka-X.broker:9092"
echo "Test $(date)" | ./bin/kafka-console-producer.sh --broker-list kafka-0.broker:9092,kafka-1.broker:9092,kafka-2.broker:9092,kafka-X.broker:9092 --topic test1
