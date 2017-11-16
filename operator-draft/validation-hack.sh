#!/bin/bash
PWD=$( pwd )
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "${NAMESPACE}" ]; then
    NAMESPACE=kafka
fi

kctl() {
    kubectl --namespace "$NAMESPACE" "$@"
}

topic=$1

[ -z "$topic" ] && echo "First argument must be a topic name" && exit 1

kctl get topic $1 || exit 1

format=$( kctl get topic sample-topic-json-001 -o jsonpath='{.spec.format}' )
schema=$( kctl get topic sample-topic-json-001 -o jsonpath='{.spec.schema}' )

echo "Format: $format"
echo "Schema:"
echo "$schema"

cd $DIR

[ -d "./node_modules/" ] || npm install --no-save ajv@5.3.0 ajv-cli@2.1.0

validate() {
  message="$1"
  [ -z "$message" ] && echo "Message is empty"  && exit 1
  ./node_modules/.bin/ajv -s <(echo $schema) -d <(echo $message)
}

# no consumer here yet
msg='{"test": true, "id": 1}'
echo "We have no consumer here yet, so the topic's schema is tested on the sample message: $msg"
validate "$msg"
if [ $? -eq 0 ]; then
  echo "= valid"
else
  echo "= invalid"
fi

cd $PWD
