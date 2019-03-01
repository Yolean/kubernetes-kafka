#!/bin/bash

IMAGE=$1
[ -z "$IMAGE" ] && echo "First argument should be the image to set" && exit 1

[[ $IMAGE != solsson/kafka:* ]] && echo "Should be the full image identifier" && exit 1

for F in kafka/ kafka/test/ zookeeper/ avro-tools/test/ maintenance/ cruise-control/ maintenance/test/; do
  sed -i "s|image: solsson/kafka:.*|image: $IMAGE|" $F*.yml
done
