
# Kafka as Kubernetes PetSet

Example of three Kafka brokers depending on three Zookeeper instances.

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

## Start Kafka

```
kubectl create -f ./
```

## Testing manually

See `./test/test.sh`.
