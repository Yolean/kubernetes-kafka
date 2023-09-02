#!/usr/bin/env bash

# Abasic bash script (I know it repeats itself) for simplicity

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$0 is located at: $DIR"

# make this file's location parents parent the working dir
cd $DIR/../../

base=$(pwd)
echo "working directory is base:\n$base"


kubectl delete -f kafka/50kafka.yml

kubectl delete -f kafka/30bootstrap-service.yml

kubectl delete -f kafka/20dns.yml

kubectl delete -f kafka/10broker-config.yml



kubectl delete -f zookeeper/51zoo.yml

kubectl delete -f zookeeper/50pzoo.yml


#kubectl delete pv,pvc -n kafka --all

kubectl delete -f variants/docker-desktop/docker-storage.yaml


kubectl delete -f zookeeper/30service.yml

kubectl delete -f zookeeper/21zoo-service.yml

kubectl delete -f zookeeper/20pzoo-service.yml

kubectl delete -f zookeeper/10zookeeper-config.yml


kubectl delete -f variants/docker-desktop/default-privilege-add.yaml


kubectl delete -f rbac-namespace-default/pod-labler.yml

kubectl delete -f rbac-namespace-default/node-reader.yml


#kubectl delete -f 00-namespace.yml














