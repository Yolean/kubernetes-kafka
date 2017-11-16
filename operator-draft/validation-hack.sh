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

format=$( kctl get topic sample-topic-json-001 -o jsonpath='{.spec.messageFormat}' )
schema=$( kctl get topic sample-topic-json-001 -o jsonpath='{.spec.schema}' )

echo "Format: $format"
echo "Schema:"
echo "$schema"
