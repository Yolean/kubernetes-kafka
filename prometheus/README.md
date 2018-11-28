# Export metrics to Prometheus

Kafka uses JMX to expose metrics, as is already [enabled](https://github.com/Yolean/kubernetes-kafka/pull/96) for broker pods. There's many ways to use JMX. For example [Kafka Manager](../yahoo-kafka-manager/) uses it to display current broker traffic.

At Yolean we use Prometheus. This folder adds a sidecar to the broker pods that exports selected JMX metrics over HTTP in Prometheus format. To add a container to an existing pod we must use the `patch`command:

```
kubectl --namespace kafka apply -f prometheus/10-metrics-config.yml 
kubectl --namespace kafka patch statefulset kafka --patch "$(cat prometheus/50-kafka-jmx-exporter-patch.yml )"
```
