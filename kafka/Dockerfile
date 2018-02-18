FROM solsson/kafka:1.0.0@sha256:17fdf1637426f45c93c65826670542e36b9f3394ede1cb61885c6a4befa8f72d

# Verifies compatibility with Yolean/kubernetes-kafka, if you use your own FROM and/or install Kafka above
RUN set -ex; \
  java -version; \
  stat ./bin/kafka-server-start.sh

ENV \
  CONFIG_MOUNT_PATH=/etc/kafka \
  KUBERNETES_VERSION=1.9.3 \
  KUBERNETES_CLIENTS_SHA256=2f509c05f0c4e1c1ac9e98879a1924f24546905349457904344d79dc639217be

COPY 10broker-config.yml $CONFIG_MOUNT_PATH/10broker-config.yml

# Extracts individual files as if config was a mounted volume
# Installs runtime dependencies for the init script
RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps=''; \
  buildDeps='curl ca-certificates jq'; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  YQ_VERSION=1.14.0; \
  YQ_SHA256=0b0b79959b24eebdfeacfe634ce906674e16e48160222a8bb91904142b9166ed; \
  curl -sLS -o /usr/local/bin/yq -k https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64; \
  echo "$YQ_SHA256  /usr/local/bin/yq" | sha256sum -c; \
  chmod u+x /usr/local/bin/yq; \
  \
  for F in init.sh server.properties log4j.properties; do yq r -j $CONFIG_MOUNT_PATH/10broker-config.yml "data[$F]" | jq -r . | tee $CONFIG_MOUNT_PATH/$F; done; \
  chmod u+x $CONFIG_MOUNT_PATH/init.sh; \
  rm $CONFIG_MOUNT_PATH/10broker-config.yml; \
  \
  curl -sLS -o k.tar.gz -k https://dl.k8s.io/v${KUBERNETES_VERSION}/kubernetes-client-linux-amd64.tar.gz; \
  echo "$KUBERNETES_CLIENTS_SHA256  k.tar.gz" | sha256sum -c; \
  tar -xvzf k.tar.gz -C /usr/local/bin/ --strip-components=3 kubernetes/client/bin/kubectl; \
  rm k.tar.gz; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt
