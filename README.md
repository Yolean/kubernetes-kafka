# Kafka for Kubernetes

This community seeks to provide:
 * Production-worthy Kafka setup for persistent (domain- and ops-) data at small scale.
 * Operational knowledge, biased towards resilience over throughput, as Kubernetes manifest.
 * A platform for event-driven (streaming!) microservices design using Kubernetes.

To quote [@arthurk](https://github.com/Yolean/kubernetes-kafka/issues/82#issuecomment-337532548):

> thanks for creating and maintaining this Kubernetes files, they're up-to-date (unlike the kubernetes contrib files, don't require helm and work great!

## Gettings started

We suggest you `apply -f` manifests in the following order:
 * You choice of storage classes from [./configure](./configure/)
 * [./rbac-namespace-default](./rbac-namespace-default/)
 * [./zookeeper](./zookeeper/)
 * [./kafka](./kafka/)

That'll give you client "bootstrap" `bootstrap.kafka.svc.cluster.local:9092`.

## Fork

Our only dependency is `kubectl`. Not because we dislike Helm or Operators, but because we think plain manifests make it easier to collaborate.
If you begin to rely on this kafka setup we recommend you fork, for example to edit [broker config](https://github.com/Yolean/kubernetes-kafka/blob/master/kafka/10broker-config.yml#L47).

## Version history

| tag   | k8s ≥ | highlights |
| ----- | ------ | ---------- |
| v3.1  | 1.8    | The painstaking path to `min.insync.replicas`=2 |
| v3.0  | 1.8    | [Outside access](#78), [modern manifests](#84), [bootstrap.kafka](#52) |
| v2.1  | 1.5    | Kafka 1.0, the init script concept |
| v2.0  | 1.5    | [addon](https://github.com/Yolean/kubernetes-kafka/labels/addon)s |
| v1.0  | 1      | Stateful? In Kubernetes? In 2016? Yes. |

All available as [releases](https://github.com/Yolean/kubernetes-kafka/releases).

## Monitoring

Have a look at:
 * [./prometheus](./prometheus/)
 * [./linkedin-burrow](./linkedin-burrow/)
 * [or plain JMX](https://github.com/Yolean/kubernetes-kafka/pull/96)
 * what's happening in the [monitoring](https://github.com/Yolean/kubernetes-kafka/labels/monitoring) label.
 * Note that this repo is intentionally light on [automation](https://github.com/Yolean/kubernetes-kafka/labels/automation). We think every SRE team must build the operational knowledge first.

## Outside (out-of-cluster) access

Available for:

 * [Brokers](./outside-services/)

## Fewer than three nodes?

For [minikube](https://github.com/kubernetes/minikube/), [youkube](https://github.com/Yolean/youkube) etc:

 * [Scale 1](https://github.com/Yolean/kubernetes-kafka/pull/44)
 * [Scale 2](https://github.com/Yolean/kubernetes-kafka/pull/118)

## Stream...

 * [Kubernetes events to Kafka](./events-kube/)
 * [Container logs to Kafka](https://github.com/Yolean/kubernetes-kafka/pull/131)
 * [Heapster metrics to Kafka](https://github.com/Yolean/kubernetes-kafka/pull/120)

## Awesome Streaming?

Kafka should only be the means to an end. How do you actually make things happen?

At Yolean we have a feeling we're reinventing a lot, but Schema Registry and Kafka Streams - as great as they are - fit few of our use cases because: a) Java only + b) not the kind of unix philosophy microservice-ish lightweight tool a small devops team like us is most productive with.

Instead of an "awesome" "curated list", let's start with labelled issues in this repo. Anyone can create them without a PR, and it facilitates discussion.

Suggested categories:

 * [howto-topics](https://github.com/Yolean/kubernetes-kafka/issues?q=label%3Ahowto-topics): Topic naming and schema management, strategies and tools. We look for parity with the REST space's API documentation (Swagger etc) and service discovery (DNS SRV etc).
 * [howto-streaming](https://github.com/Yolean/kubernetes-kafka/issues?q=label%3Ahowto-streaming): Lightweight streaming abstractions for different languages. Or as container images.
   - filter, like bash + [kafkacat](https://github.com/edenhill/kafkacat) `|` [jq](https://github.com/stedolan/jq)
   - split topic by field x, the value of x used for dynamic topic names
   - join topics (consume using regex, write to single topic)
   - count occurences based on regex or jq, export to [Prometheus](https://prometheus.io/docs/concepts/metric_types/#counter)
   - stream-table joins in non-JVM languages
 * [howto-frontend](https://github.com/Yolean/kubernetes-kafka/issues?q=label%3Ahowto-frontend): At-leat-once transport over HTTP. Reactive front-ends are as great a paradigm as event-driven services, but the tooling tends to be low-level ([socket.io](https://socket.io/) etc) or require us to emulate pubsub over request-response ([graphql](http://graphql.org/) etc).
 * [howto-frontend](https://github.com/Yolean/kubernetes-kafka/issues?q=label%3Ahowto-frontend): Lightweight state cache, based on resolving events to state, for different languages. We felt we had to write [kafka-cache](https://github.com/Yolean/kafka-cache) for Node.js. Again Kafka Streams does such things, but not really as "do one thing and do it well".

Please share your ideas and observactions.
