## Cruise Control

Cruise Control is used to automate the dynamic workload rebalance and self-healing of a Kafka cluster. This tool will allow you to add, replace or remove nodes and the cluster will be automatically adjusted. Partitions will be rebalanced based on resource usage of CPU, network, disk, etc.

*Disclaimer*: It is important to understand Cruise Control will modify the Kafka cluster without operator intervention. Bugs or misconfiguration may cause loss of data or denial of service. You bear the responsibility of configuring and testing properly and taking precautions based on the importance of your data.

### Configuration

There are several configuration files that need to be mounted in `/opt/cruise-control/config`. The files in `11cruise-control-config.yml` are the defaults from [the Cruise Control GitHub repo, migrate_to_kafka_2_0 branch](https://github.com/linkedin/cruise-control/tree/migrate_to_kafka_2_0/config). The significant modification from the GitHub repo is that self healing has been enabled using `self.healing.enabled=true`.

Following are the files in `11cruise-control-config.yml`. Nearly all changes you would make are in `cruisecontrol.properties`.

- cruisecontrol.properties
- capacityJBOD.json
- capacity.json
- clusterConfigs.json
- log4j2.xml
- log4j.properties

### Patching

Cruise control requires broker metrics to make informed decisions. Each broker runs a metric collector that pushes metrics into a topic, by default named `__CruiseControlMetrics`. Configuring the collector requires patching the broker StatefulSet. An example command to apply this patch is below.

```shell
$ kubectl --namespace kafka patch statefulset kafka --patch "$(cat cruise-control/20kafka-broker-reporter-patch.yml)"
```
