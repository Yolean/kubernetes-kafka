#!/bin/bash

IMAGE=$1
[ -z "$IMAGE" ] && echo "First argument should be the image to set" && exit 1

for F in ./ test/ zookeeper/; do
  sed -i '' "s|image: solsson/kafka:.*|image: $IMAGE|" $F*.yml
done
