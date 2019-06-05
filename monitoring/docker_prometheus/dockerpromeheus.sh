#!/bin/bash

echo '{' >> /etc/docker/daemon.json
echo '  "metrics-addr" : "127.0.0.1:9323",' >> /etc/docker/daemon.json
echo '  "experimental" : true' >> /etc/docker/daemon.json
echo '}' >> /etc/docker/daemon.json

cp prometheus.yml /tmp/
chmod 777 /tmp/prometheus.yml

service docker restart
service docker status

/usr/local/bin/docker-compose up -d

#docker run --rm -d -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml --network host -p 9090:9090 prom/prometheus

#docker run --rm -d --network host -p 3000:3000 -e GF_SECURITY_ADMIN_USER=admin -e GF_SECURITY_ADMIN_PASSWORD=secret grafana/grafana:5.0.0

/usr/local/bin/docker-compose ps
