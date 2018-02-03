
## Re-assign Leadership

This is one of the cases where this repo begs to differ from traditional Kafka setups.
In Kubernetes the restart of a pod, and subsequent start on a different node, should be a non-event.

> ”when a broker is stopped and restarted, it does not resume leadership of any partitions automatically”

_-- Neha Narkhede, Gwen Shapira, and Todd Palino. ”Kafka: The Definitive Guide”_

Create the `preferred-replica-election-job.yml` resource, after deleting any previous one.

## Change a Partition's Replicas

> ”From time to time, it may be necessary to change the replica assignments for a partition. Some examples of when this might be needed are:
>  * If a topic’s partitions are not balanced across the cluster, causing uneven load on brokers
>  * If a broker is taken offline and the partition is under-replicated
>  * If a new broker is added and needs to receive a share of the cluster load”

_-- Neha Narkhede, Gwen Shapira, and Todd Palino. ”Kafka: The Definitive Guide”_

Use the `reassign-paritions-job.yml`, after editing `TOPICS` and `BROKERS`.

## Increase a topic's replication factor

See https://github.com/Yolean/kubernetes-kafka/pull/140

Use the `replication-factor-increase-job.yml`, after editing `TOPICS` and `BROKERS`.

The affected topics may end up without a preferred replica. See above to fix that,
or to affect only your selected topics use [Kafka Manager](https://github.com/Yolean/kubernetes-kafka/pull/83)'s topic screen,
Generate Partition Assignments followed by Reassign Partitions.
