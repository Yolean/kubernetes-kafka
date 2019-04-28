FROM busybox as entrypoint

RUN printf '#!/bin/sh\
# Brings up a kubernetes-kafka cluster in local docker. For example: \n\
#docker run -v /var/run/docker.sock:/var/run/docker.sock:rw --net=host --name kafka-quickstart -ti solsson/kubernetes-kafka:kind \n\
\n\
kind create cluster --name=$KIND_NAME \n\
echo KUBECONFIG=$KUBECONFIG \n\
kubectl cluster-info \n\
\n\
echo "To get local kubectl access (with --net=host) run for example:" \n\
echo "docker cp kafka-quickstart:/root/.kube/kind-config-$KIND_NAME ./kubeconfig-local-kubernetes-kafka" \n\
echo "export KUBECONFIG=\$(pwd)/kubeconfig-local-kubernetes-kafka" \n\
\n\
echo "Will now attempt an automated kafka setup ..." \n\
sleep 10 \n\
kubectl -n kube-system get pods \n\
kubectl wait --for=condition=Ready --timeout=120s -n kube-system pod --all \n\
\n\
kubectl apply -f 00-namespace.yml \n\
kubectl apply -f rbac-namespace-default/ \n\
kubectl apply -k variants/scale-1-ephemeral/ \n\
sleep 10 \n\
kubectl -n kafka get pods \n\
kubectl -n kafka wait --for=condition=Ready --timeout=120s pod/kafka-0 \n\
\n\
echo "Local kafka access requires a hosts file entry 127.0.0.1  kafka-0.broker.kafka.svc.cluster.local" \n\
echo "kubectl -n kafka port-forward kafka-0 9092" \n\
\n\
echo "To delete the cluster simply rm this container and $KIND_NAME-control-plane" \n\
'\
>> /entrypoint

FROM docker:18.09.5-dind@sha256:7ed03cb37cbe109867455393e670016149ae80fde931cf4773fabd8cf6284ee6 \
  as docker

FROM lachlanevenson/k8s-kubectl:v1.14.1@sha256:8267b932d262f0fc2c901f515d7752dd9e7c60c8410086e7a9fda935bcc3ba0d \
  as kubectl

FROM golang:1.12.4-alpine \
  as kind

ENV KIND_VERSION=0.2.1
ENV GO111MODULE=on
RUN set -e; \
  apk add --no-cache git; \
  go get sigs.k8s.io/kind@${KIND_VERSION}

FROM alpine:3.9@sha256:28ef97b8686a0b5399129e9b763d5b7e5ff03576aa5580d6f4182a49c5fe1913 \
  as runner

COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=kind /go/bin/kind /usr/local/bin/kind

WORKDIR /kubernetes-kafka
COPY . .

ENV KIND_NAME=kafka KUBECONFIG=/root/.kube/kind-config-kafka

COPY --from=entrypoint /entrypoint /entrypoint
RUN chmod u+x /entrypoint

ENTRYPOINT ["/entrypoint"]
