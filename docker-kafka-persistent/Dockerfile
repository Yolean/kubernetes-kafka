
FROM openjdk:8u121-jre

ENV kafka_version=0.10.2.0
ENV scala_version=2.12.1
ENV kafka_bin_version=2.12-$kafka_version

RUN curl -SLs "http://www.scala-lang.org/files/archive/scala-$scala_version.deb" -o scala.deb \
	&& dpkg -i scala.deb \
	&& rm scala.deb \
	&& curl -SLs "http://www.apache.org/dist/kafka/$kafka_version/kafka_$kafka_bin_version.tgz" | tar -xzf - -C /opt \
	&& mv /opt/kafka_$kafka_bin_version /opt/kafka

WORKDIR /opt/kafka
ENTRYPOINT ["bin/kafka-server-start.sh"]

ADD config/server.properties config/

CMD ["config/server.properties"]
