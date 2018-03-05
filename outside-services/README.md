## Expose Kafka outside cluster
For `broker/`

Currently supported for brokers, not zookeeper.

This folder only creates sample services for NodePort access, i.e. inside any firewalls that protect your cluster. Can be switched to LoadBalancer, but then the init script for brokers must be updated to retrieve external names. See discussions around https://github.com/Yolean/kubernetes-kafka/pull/78 for examples.

## Expose Avro Schema Registry outside of cluster
For `schema-registry/`

Allows applications/services outside of the cluster to communicate with the `schema-registry` on port 31111 (default). Used with [avro-tools](../avro-tools/).