#!/bin/bash
# Combines addons into what we 'kubectl apply -f' to production
set -ex

git fetch
git checkout origin/kafka-011
git checkout -b prod-yolean-$(date +"%Y%m%dT%H%M%S")

for BRANCH in \
  addon-storage-classes \
  addon-metrics \
  addon-rest \
  addon-kube-events-topic
do
  git merge --no-ff $BRANCH -m "prod-yolean merge $BRANCH"
done
