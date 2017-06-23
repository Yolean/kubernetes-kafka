#!/bin/bash

echo "Note that in for example GKE a StatefulSet will have PersistentVolume(s) and PersistentVolumeClaim(s) created for it automatically"

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
path="$dir/data"
echo "Please enter a path where to store data during local testing: ($path)"
read newpath
[ -n "$newpath" ] && path=$newpath

cat bootstrap/pv-template.yml | sed "s|/tmp/k8s-data|$path|" | kubectl create -f -
