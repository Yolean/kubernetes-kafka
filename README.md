
# Kafka as Kubernetes PetSet

Example of three Kafka brokers depending on three Zookeeper instances.

To get consistent service DNS names `kafka-N.broker.kafka`(`.svc.cluster.local`), run everything in a namespace:
```
kubectl create -f 00namespace.yml
```

A typical Kafka install (see `docker-images` branch) comes with more config files than the server needs.
The PetSet mounts instead a [ConfigMap](http://kubernetes.io/docs/user-guide/configmap/) with a minimal set of files.
Load `./config/` into Kubernetes using:
```
./bootstrap/config.sh
```

## Set up volume claims

This step can be skipped in clusters that support automatic volume provisioning, such as GKE.

You need this step in Minikube.

```
./zookeeper/bootstrap/pv.sh
kubectl create -f ./zookeeper/bootstrap/pvc.yml
```

```
./bootstrap/pv.sh
kubectl create -f ./bootstrap/pvc.yml
# check that claims are bound
kubectl get pvc
```

The volume size in the example is very small. The numbers don't really matter as long as they match. Minimal size on GKE is 1 GB.

## Set up Zookeeper

This module contains a copy of `pets/zookeeper/` from https://github.com/kubernetes/contrib.

See the `./zookeeper` folder and follow the README there.

An additional service has been added here, create using:
```
kubectl create -f ./zookeeper/service.yml
```

## Start Kafka

```
kubectl create -f ./
```

You might want to verify in logs that Kafka found its own DNS name(s) correctly. Look for records like:
```
kubectl logs kafka-0 | grep "Registered broker"
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

## Teardown & cleanup

Testing and retesting... delete the namespace. PVs are outside namespaces so delete them too.
```
kubectl delete namespace kafka
rm -R ./data/ && kubectl delete pv datadir-zoo-0 datadir-zoo-1 datadir-zoo-2
rm -R ./data/ && kubectl delete pv datadir-kafka-0 datadir-kafka-1 datadir-kafka-2
```
