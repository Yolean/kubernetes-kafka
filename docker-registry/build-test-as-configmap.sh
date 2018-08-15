#!/bin/bash
set -e
set -x

# We use a configmap to fake git clone into build-contract runner pod

cd build-contract-test/
[ -d .git ] && rm -rf .git
git init
rm -rf .git/hooks/*.sample
git add .
git commit -m "A minimal build-contract compliant module"
tar cvfz ../build-contract-test.tgz .git Dockerfile build-contracts/
cd ..
kubectl -n build delete configmap build-test-tarballs
kubectl -n build create configmap build-test-tarballs --from-file=./build-contract-test.tgz
kubectl -n build get configmap build-test-tarballs --export -o yaml > build-test-tarballs.yml
