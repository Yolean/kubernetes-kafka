#!/bin/bash
# Combines addons into what we 'kubectl apply -f' to production
set -ex

ANNOTATION_PREFIX='yolean.se/kubernetes-kafka-'
BUILD=$(basename $0)

function annotate {
  key=$1
  value=$2
  file=$3
  sed -i "s|      annotations:|      annotations:\n        ${ANNOTATION_PREFIX}$key: '$value'|" $file
}

git fetch
git checkout origin/master

echo "Working copy must be clean"
[ -z "$(git status --untracked-files=no -s)" ]
START_REV_GIT=$(git rev-parse --short HEAD)

git checkout -b prod-yolean-$(date +"%Y%m%dT%H%M%S")

for BRANCH in \
  addon-storage-classes \
  addon-metrics \
  addon-rest \
  addon-kube-events-topic
do
  git merge --no-ff $BRANCH -m "prod-yolean merge $BRANCH"
done

END_BRANCH_GIT=$(git rev-parse --abbrev-ref HEAD)

for F in ./50kafka.yml ./zookeeper/50pzoo.yml ./zookeeper/51zoo.yml
do
  annotate fromrev $START_REV_GIT $F
  annotate build $END_BRANCH_GIT $F
done
