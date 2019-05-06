# Export metrics to Prometheus

JMX is already [enabled](https://github.com/Yolean/kubernetes-kafka/pull/96) for broker pods (TODO extract to kustomization). There's many ways to use JMX. For example [Kafka Manager](../yahoo-kafka-manager/) uses it to display current broker traffic.

This folder adds a sidecar to the broker pods that exports selected JMX metrics over HTTP in Prometheus format. To add a container to an existing pod we must use the `patch`command:

Using kubectl 1.14+

```
kubectl --namespace kafka apply -k prometheus/
```

Using pre-1.14 kubectl:

```
kubectl --namespace kafka apply -f prometheus/10-metrics-config.yml 
kubectl --namespace kafka patch statefulset kafka --patch "$(cat prometheus/50-kafka-jmx-exporter-patch.yml )"
```

## Consumer lag monitoring

See [Burrow](../linkedin-burrow)
or [Kafka Minion](../consumers-prometheus/)

## Prometheus Operator

Use the [prometheus-operator](../variants/prometheus-operator/) kustomization.
