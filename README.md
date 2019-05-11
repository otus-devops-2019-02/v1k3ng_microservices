[![Build Status](https://travis-ci.com/otus-devops-2019-02/v1k3ng_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/v1k3ng_microservices)


# Readme homework #16

Настройка docker-machine. Для работы с gce нужно либо указать переменную окружения:  
```
export GOOGLE_PROJECT=docker-240004
```
Либо задать ключ **--google-project docker-240004**:
```
docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-zone europe-west1-b \
    --google-project docker-240004 \
    docker-host
```

Создание образов из **Dockerfile**:  
```
docker build -t mad72/post:1.0 ./post-py
docker build -t mad72/comment:1.0 ./comment
docker build -t mad72/ui:1.0 ./ui
```
**docker exec -it <container_name> /bin/bash** - подключиться к шеллу контейнера (без docker-machine)  
**docker network create reddit** - создать сеть reddit для контейнеров  

Запускаем сразу всю пачку созданных контейнеров (без volume):
```
docker run --rm -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run --rm -d --network=reddit --network-alias=post mad72/post:1.0
docker run --rm -d --network=reddit --network-alias=comment mad72/comment:1.0
docker run --rm -d --network=reddit -p 9292:9292 mad72/ui:1.0
```
Запускаем сразу всю пачку созданных контейнеров (с volume):
```
docker run --rm -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
docker run --rm -d --network=reddit --network-alias=post mad72/post:1.0
docker run --rm -d --network=reddit --network-alias=comment mad72/comment:1.0
docker run --rm -d --network=reddit -p 9292:9292 mad72/ui:1.0
```
Запуск всей пачки контейнеров **с измененными переменными имен хостов**:  
```
docker network create reddit
docker run -d --network=reddit \
    --network-alias=post_db1 \
    --network-alias=comment_db1 mongo:latest
docker run -d --network=reddit \
    -e POST_DATABASE_HOST=post_db1 \
    -e POST_DATABASE=posts \
    --network-alias=post1 \
    mad72/post:1.0
docker run -d --network=reddit \
    -e COMMENT_DATABASE_HOST=comment_db1 \
    -e COMMENT_DATABASE=comments \
    --network-alias=comment1 \
    mad72/comment:1.0
docker run -d --network=reddit \
    -e POST_SERVICE_HOST=post1 \
    -e POST_SERVICE_PORT=5000 \
    -e COMMENT_SERVICE_HOST=comment1 \
    -e COMMENT_SERVICE_PORT=9292 \
    -p 9292:9292 \
    mad72/ui:1.0
```

**docker kill $(docker ps -q)** - убить весь запущенные контейнеры  

Используем **--squash** для уменьшения размера контейнеров. Но мне почему-то не помогло ни на килобайт:  
```
docker build --squash -t mad72/post:1.0 ./post-py
docker build --squash -t mad72/comment:1.0 ./comment
docker build --squash -t mad72/ui:1.0 ./ui
```
**docker volume create reddit_db** - создать volume  
После чего подключаем volume ключом **-v reddit_db:/data/db**  


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
