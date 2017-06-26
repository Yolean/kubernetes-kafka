
# Kafka as Kubernetes StatefulSet

Example of three Kafka brokers depending on five Zookeeper instances.

To get consistent service DNS names `kafka-N.broker.kafka`(`.svc.cluster.local`), run everything in a [namespace](http://kubernetes.io/docs/admin/namespaces/walkthrough/):
```
kubectl create -f 00namespace.yml
```

## Set up volume claims

You may add [storage class](http://kubernetes.io/docs/user-guide/persistent-volumes/#storageclasses)
to the kafka StatefulSet declaration to enable automatic volume provisioning.

Alternatively create [PV](http://kubernetes.io/docs/user-guide/persistent-volumes/#persistent-volumes)s and [PVC](http://kubernetes.io/docs/user-guide/persistent-volumes/#persistentvolumeclaims)s manually. For example in Minikube.

```
./bootstrap/pv.sh
kubectl create -f ./10pvc.yml
# check that claims are bound
kubectl -n kafka get pvc
```

## Set up Zookeeper

The Kafka book (Definitive Guide, O'Reilly 2016) recommends that Kafka has its own Zookeeper cluster with at least 5 instances.
We use the zookeeper build that comes with the Kafka distribution, and tweak the startup command to support StatefulSet.

```
kubectl create -f ./zookeeper/
```

## Start Kafka

Assuming you have your PVCs `Bound`, or enabled automatic provisioning (see above), go ahead and:

```
kubectl create -f ./
```

You might want to verify in logs that Kafka found its own DNS name(s) correctly. Look for records like:
```
kubectl -n kafka logs kafka-0 | grep "Registered broker"
# INFO Registered broker 0 at path /brokers/ids/0 with addresses: PLAINTEXT -> EndPoint(kafka-0.broker.kafka.svc.cluster.local,9092,PLAINTEXT)
```

## Testing manually

There's a Kafka pod that doesn't start the server, so you can invoke the various shell scripts.
```
kubectl create -f test/99testclient.yml
```

See `./test/test.sh` for some sample commands.

## Automated test, while going chaosmonkey on the cluster

This is WIP, but topic creation has been automated. Note that as a [Job](http://kubernetes.io/docs/user-guide/jobs/), it will restart if the command fails, including if the topic exists :(
```
kubectl create -f test/11topic-create-test1.yml
```

Pods that keep consuming messages (but they won't exit on cluster failures)
```
kubectl create -f test/21consumer-test1.yml
```

## Teardown & cleanup

Testing and retesting... delete the namespace. PVs are outside namespaces so delete them too.
```
kubectl delete namespace kafka
rm -R ./data/ && kubectl -n kafka delete pv datadir-kafka-0 datadir-kafka-1 datadir-kafka-2
```

## Metrics, Prometheus style

Is the metrics system up and running?
```
kubectl logs -c metrics kafka-0
kubectl exec -c broker kafka-0 -- /bin/sh -c 'apk add --no-cache curl && curl http://localhost:5556/metrics'
kubectl logs -c metrics zoo-0
kubectl exec -c zookeeper zoo-0 -- /bin/sh -c 'apk add --no-cache curl && curl http://localhost:5556/metrics'
```
