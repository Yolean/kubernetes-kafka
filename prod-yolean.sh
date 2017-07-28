#!/bin/bash
# Combines addons into what we 'kubectl apply -f' to production
set -ex

ANNOTATION_NAMESPACE='yolean.se/kubernetes-kafka'

git fetch
git checkout origin/kafka-011

#[ -z "$(git status --untracked-files=no -s)" ]
GIT_START_REV=$(git rev-parse --short HEAD)

#echo "ok done" && exit 0;
#git checkout -b prod-yolean-$(date +"%Y%m%dT%H%M%S")

for BRANCH in \
  addon-storage-classes \
  addon-metrics \
  addon-rest \
  addon-kube-events-topic
do
  echo git merge --no-ff $BRANCH -m "prod-yolean merge $BRANCH"
done

for F in ./50kafka.yml ./zookeeper/50pzoo.yml ./zookeeper/51zoo.yml
do
  echo "$F"
  sed -i '' "s|      annotations:|      annotations:\\n        $ANNOTATION_NAMESPACE/start-rev-git: '$GIT_START_REV'|" $F
  # TODO git remote
  # TODO result after merge, branches/branch name
done
