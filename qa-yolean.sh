#!/bin/bash
# Combines addons into what we 'kubectl apply -f' to production
set -ex

ANNOTATION_PREFIX='yolean.se/kubernetes-kafka-'
BUILD=$(basename $0)
REMOTE=origin
FROM="$REMOTE/"
START=master

[ ! -z "$(git status --untracked-files=no -s)" ] && echo "Working copy must be clean" && exit 1

function annotate {
  key=$1
  value=$2
  file=$3
  case $(uname) in
    Darwin*)
      sed -i '' 's|      annotations:|      annotations:\
        --next-annotation--|' $file
      sed -i '' "s|--next-annotation--|${ANNOTATION_PREFIX}$key: '$value'|" $file
      ;;
    *)
      sed -i "s|      annotations:|      annotations:\n        ${ANNOTATION_PREFIX}$key: '$value'|" $file
      ;;
  esac
}

git checkout ${FROM}$START
REVS="$START:$(git rev-parse --short ${FROM}$START)"

git checkout -b qa-yolean-$(date +"%Y%m%dT%H%M%S")

for BRANCH in \
  addon-storage-classes \
  rolling-update \
  addon-metrics \
  addon-kube-events-topic
do
  git merge --no-ff ${FROM}$BRANCH -m "qa-yolean merge ${FROM}$BRANCH" && \
    REVS="$REVS $BRANCH:$(git rev-parse --short ${FROM}$BRANCH)"
done

END_BRANCH_GIT=$(git rev-parse --abbrev-ref HEAD)

for F in ./50kafka.yml ./zookeeper/50pzoo.yml ./zookeeper/51zoo.yml
do
  annotate revs "$REVS" $F
  annotate build "$END_BRANCH_GIT" $F
done
