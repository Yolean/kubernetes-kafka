_Manifests here require Kubernetes 1.8 now.
On earlier versions use [v2.1.0](https://github.com/Yolean/kubernetes-kafka/tree/v2.1.0)._

# Kafka on Kubernetes

Transparent Kafka setup that you can grow with.
Good for both experiments and production.

How to use:
 * Good to know: you'll likely want to fork this repo. It prioritizes clarity over configurability, using plain manifests and .propeties files; no client side logic.
 * Run a Kubernetes cluster, [minikube](https://github.com/kubernetes/minikube) or real.
 * Quickstart: use the `kubectl apply`s below.
 * Have a look at [addon](https://github.com/Yolean/kubernetes-kafka/labels/addon)s, or the official forks:
   - [kubernetes-kafka-small](https://github.com/Reposoft/kubernetes-kafka-small) for single-node clusters like Minikube.
   - [StreamingMicroservicesPlatform](https://github.com/StreamingMicroservicesPlatform/kubernetes-kafka) Like Confluent's [platform quickstart](https://docs.confluent.io/current/connect/quickstart.html) but for Kubernetes.
 * Join the discussion in issues and PRs.

No readable readme can properly introduce both [Kafka](http://kafka.apache.org/) and [Kubernetes](https://kubernetes.io/),
but we think the combination of the two is a great backbone for microservices.
Back when we read [Newman](http://samnewman.io/books/building_microservices/) we were beginners with both.
Now we've read [Kleppmann](http://dataintensive.net/), [Confluent](https://www.confluent.io/blog/) and [SRE](https://landing.google.com/sre/book.html) and enjoy this "Streaming Platform" lock-in :smile:.

We also think the plain-yaml approach of this project is easier to understand and evolve than [helm](https://github.com/kubernetes/helm) [chart](https://github.com/kubernetes/charts/tree/master/incubator/kafka)s.

## What you get

Keep an eye on `kubectl --namespace kafka get pods -w`.

The goal is to provide [Bootstrap servers](http://kafka.apache.org/documentation/#producerconfigs): `kafka-0.broker.kafka.svc.cluster.local:9092,kafka-1.broker.kafka.svc.cluster.local:9092,kafka-2.broker.kafka.svc.cluster.local:9092`
`

Zookeeper at `zookeeper.kafka.svc.cluster.local:2181`.

## Prepare storage classes

For Minikube run `kubectl apply -f configure/minikube-storageclass-broker.yml; kubectl apply -f configure/minikube-storageclass-zookeeper.yml`.

There's a similar setup for GKE, `configure/gke-*`. You might want to tweak it before creating.

## Start Zookeeper

The [Kafka book](https://www.confluent.io/resources/kafka-definitive-guide-preview-edition/) recommends that Kafka has its own Zookeeper cluster with at least 5 instances.

```
kubectl apply -f ./zookeeper/
```

To support automatic migration in the face of availability zone unavailability we mix persistent and ephemeral storage.

## Start Kafka

```
kubectl apply -f ./kafka/
```

You might want to verify in logs that Kafka found its own DNS name(s) correctly. Look for records like:
```
kubectl -n kafka logs kafka-0 | grep "Registered broker"
# INFO Registered broker 0 at path /brokers/ids/0 with addresses: PLAINTEXT -> EndPoint(kafka-0.broker.kafka.svc.cluster.local,9092,PLAINTEXT)
```

That's it. Just add business value :wink:.

## RBAC

For clusters that enfoce [RBAC](https://kubernetes.io/docs/admin/authorization/rbac/) there's a minimal set of policies in
```
kubectl apply -f rbac-namespace-default/
```

## Tests

Tests are based on the [kube-test](https://github.com/Yolean/kube-test) concept.
Like the rest of this repo they have `kubectl` as the only local dependency.

Run self-tests or not. They do generate some load, but indicate if the platform is working or not.
 * To include tests, replace `apply -f` with `apply -R -f` in your `kubectl`s above.
 * Anything that isn't READY in `kubectl get pods -l test-type=readiness --namespace=test-kafka` is a failed test.
