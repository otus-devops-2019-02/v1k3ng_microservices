#!/bin/bash

# echo '{' >> /etc/docker/daemon.json
# echo '  "metrics-addr" : "127.0.0.1:9323",' >> /etc/docker/daemon.json
# echo '  "experimental" : true' >> /etc/docker/daemon.json
# echo '}' >> /etc/docker/daemon.json

cp prometheus.yml /tmp/
chmod 777 /tmp/prometheus.yml

cp telegraf.conf /tmp/
chmod 777 /tmp/telegraf.conf


# service docker restart
# service docker status

/usr/local/bin/docker-compose up -d
/usr/local/bin/docker-compose ps
