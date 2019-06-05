#!/bin/bash
echo "{" >> /etc/docker/docker.json
echo "  \"metrics-addr\" : "127.0.0.1:9323"," >> /etc/docker/docker.json
echo "  \"experimental\" : true" >> /etc/docker/docker.json
echo "}" >> /etc/docker/docker.json
service docker restart