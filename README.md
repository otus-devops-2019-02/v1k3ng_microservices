[![Build Status](https://travis-ci.com/otus-devops-2019-02/v1k3ng_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/v1k3ng_microservices)

# Readme homework #15

Создание при помощи docker-machine инстанса в GCE:  
```
docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
--google-machine-type n1-standard-1 \
--google-zone europe-west1-b \
docker-host
```
**docker run --rm -ti tehbilly/htop** - запуск контейнера  
**docker run --rm --pid host -ti tehbilly/htop** - запуск контейнера в пространстве pid хостовой машины  
**docker-machine create <имя>** - создать инстанс docker-machine  
**docker-machine rm <имя>** - удалить инстанс docker-machine
**docker-machine ls** - показать список инстансов docker-machine
**eval $(docker-machine env <имя>)** - переключение инстансов docker-machine  
**eval $(docker-machine env --unset)** - переключение на локальный инстанс docker-machine

**docker build -t reddit:latest .** - создать образ из Dockerfile
**docker images -a** - список ВСЕХ images 
**docker run --name reddit -d --network=host reddit:latest** - запуск контейнера с общей сетью с хостовой машиной  

На всякий случай - создание правил файервола
```
gcloud compute firewall-rules create reddit-app \
--allow tcp:9292 \
--target-tags=docker-machine \
--description="Allow PUMA connections" \
--direction=INGRESS
```

**docker tag reddit:latest mad72/otus-reddit:1.0** - тэгирование образа
**docker push mad72/otus-reddit:1.0** - пуш образа в docker hub
