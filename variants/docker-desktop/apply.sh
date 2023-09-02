#!/usr/bin/env bash

# Abasic bash script (I know it repeats itself) for simplicity

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$0 is located at: $DIR"

# make this file's location parents parent the working dir
cd $DIR/../../

base=$(pwd)
echo "working directory is base:\n$base"


kubectl apply -f 00-namespace.yml


kubectl apply -f variants/docker-desktop/docker-storage.yaml


kubectl apply -f rbac-namespace-default/node-reader.yml

kubectl apply -f rbac-namespace-default/pod-labler.yml


kubectl apply -f variants/docker-desktop/default-privilege-add.yaml


kubectl apply -f zookeeper/10zookeeper-config.yml

kubectl apply -f zookeeper/20pzoo-service.yml

kubectl apply -f zookeeper/21zoo-service.yml

kubectl apply -f zookeeper/30service.yml

kubectl apply -f zookeeper/50pzoo.yml

kubectl apply -f zookeeper/51zoo.yml


kubectl apply -f kafka/10broker-config.yml

kubectl apply -f kafka/20dns.yml

kubectl apply -f kafka/30bootstrap-service.yml

kubectl apply -f kafka/50kafka.yml