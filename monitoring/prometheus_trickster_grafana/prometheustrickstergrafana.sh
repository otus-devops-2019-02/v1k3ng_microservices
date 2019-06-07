#!/bin/bash

sudo cp trickster.conf /tmp/
sudo chmod 777 /tmp/trickster.conf

sudo cp prometheus.yml /tmp/
sudo chmod 777 /tmp/prometheus.yml

/usr/local/bin/docker-compose up -d
/usr/local/bin/docker-compose ps
