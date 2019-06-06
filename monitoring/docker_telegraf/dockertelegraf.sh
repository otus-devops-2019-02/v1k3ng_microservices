#!/bin/bash

# sudo echo '{' >> /etc/docker/daemon.json
# sudo echo '  "metrics-addr" : "127.0.0.1:9323",' >> /etc/docker/daemon.json
# sudo echo '  "experimental" : true' >> /etc/docker/daemon.json
# sudo echo '}' >> /etc/docker/daemon.json

sudo cp prometheus.yml /tmp/
sudo chmod 777 /tmp/prometheus.yml

sudo cp telegraf.conf /tmp/
sudo chmod 777 /tmp/telegraf.conf


service docker restart
# service docker status

/usr/local/bin/docker-compose up -d
/usr/local/bin/docker-compose ps

#209 metrics
