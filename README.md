# Kafka for Kubernetes

This community seeks to provide:
 * Production-worthy Kafka setup for persistent (domain- and ops-) data at small scale.
 * Operational knowledge, biased towards resilience over throughput, as Kubernetes manifest.
 * A platform for event-driven (streaming!) microservices design using Kubernetes.

To quote [@arthurk](https://github.com/Yolean/kubernetes-kafka/issues/82#issuecomment-337532548):

> thanks for creating and maintaining this Kubernetes files, they're up-to-date (unlike the kubernetes contrib files, don't require helm and work great!

## Getting started

We suggest you `apply -f` manifests in the following order:
 * [namespace](./00-namespace.yml)
 * [./rbac-namespace-default](./rbac-namespace-default/)
 * [./zookeeper](./zookeeper/)
 * [./kafka](./kafka/)

That'll give you client "bootstrap" `bootstrap.kafka.svc.cluster.local:9092`.

## Fork

Our only dependency is `kubectl`. Not because we dislike Helm or Operators, but because we think plain manifests make it easier to collaborate.
If you begin to rely on this kafka setup we recommend you fork, for example to edit [broker config](https://github.com/Yolean/kubernetes-kafka/blob/master/kafka/10broker-config.yml#L47).

## Kustomize

With the introduction of [app customization](https://kubectl.docs.kubernetes.io/pages/app_customization/introduction.html) in `kubectl` 1.14 there's an alternative to forks. We as a community can maintain a set of overlays.

See the [variants](./variants) folder for different overlays. For example to scale to 1 kafka broker try `kubectl apply -k variants/scale-1/`.
Variants also include examples of how to configure volumes for GKE, AWS and AKS with different storage classes.

### Quickstart

```
kubectl create namespace kafka && \
kubectl apply -k github.com/Yolean/kubernetes-kafka/variants/dev-small/?ref=v6.0.3
```

When all pods are Ready, test with for example `kafkacat -b localhost:9094 -L` over `kubectl -n kafka port-forward kafka-0 9094`.

### Maintaining your own kustomization

Start your variant as a new folder in your choice of version control, with a base `kustomization.yaml` pointing to a tag or revision in this repository:

```
bases:
- github.com/Yolean/kubernetes-kafka/rbac-namespace-default/?ref=60d01b5
- github.com/Yolean/kubernetes-kafka/kafka/?ref=60d01b5
- github.com/Yolean/kubernetes-kafka/zookeeper/?ref=60d01b5
```

Then pick and chose from patches our [example variants](https://github.com/Yolean/kubernetes-kafka/tree/master/variants) to tailor your Kafka setup.

## Version history

| tag    | k8s ≥ | highlights  |
| ------ | ----- | ----------- |
| v7.0.0 | 1.15+ | [Breaking](https://github.com/Yolean/kubernetes-kafka/pull/311#issuecomment-657181714) with [nonroot](./nonroot/) and [native](./native/) bases |
| v6.0.x | 1.13+ | Kafka [2.4.0](https://github.com/Yolean/kubernetes-kafka/pull/297) + [standard storage class](https://github.com/Yolean/kubernetes-kafka/pull/294) |
| v6.0.0 | 1.11+ | Kafka 2.2.0 + `apply -k` (kubectl 1.14+) + [#270](https://github.com/Yolean/kubernetes-kafka/pull/270) |
| v5.1.0 | 1.11+ | Kafka 2.1.1 |
| v5.0.3 | 1.11+ | Zookeeper fix [#227](https://github.com/Yolean/kubernetes-kafka/pull/227) + [maxClientCnxns=1](https://github.com/Yolean/kubernetes-kafka/pull/230#issuecomment-445953857) |
| v5.0  | 1.11+  | Destabilize because in Docker we want Java 11 [#197](https://github.com/Yolean/kubernetes-kafka/pull/197) [#191](https://github.com/Yolean/kubernetes-kafka/pull/191) |
| v4.3.1 | 1.9+  | Critical Zookeeper persistence fix [#228](https://github.com/Yolean/kubernetes-kafka/pull/228) |
| v4.3  | 1.9+   | Adds a proper shutdown hook [#207](https://github.com/Yolean/kubernetes-kafka/pull/207) |
| v4.2  | 1.9+   | Kafka 1.0.2 and tools upgrade |
|       |        | ... see [releases](https://github.com/Yolean/kubernetes-kafka/releases) for full history ... |
| v1.0  | 1      | Stateful? In Kubernetes? In 2016? Yes. |

## Monitoring

Have a look at:
 * [./prometheus](./prometheus/)
 * [./linkedin-burrow](./linkedin-burrow/)
 * [./consumers-prometheus](./consumers-prometheus/)
 * [or plain JMX](https://github.com/Yolean/kubernetes-kafka/pull/96)
 * what's happening in the [monitoring](https://github.com/Yolean/kubernetes-kafka/labels/monitoring) label.
 * Note that this repo is intentionally light on [automation](https://github.com/Yolean/kubernetes-kafka/labels/automation). We think every SRE team must build the operational knowledge first. But there is an example of a [Cruise Control](./cruise-control/) setup.

## Outside (out-of-cluster) access

Available for:

 * [Brokers](./outside-services/)

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
