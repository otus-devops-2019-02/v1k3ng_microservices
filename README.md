[![Build Status](https://travis-ci.com/otus-devops-2019-02/v1k3ng_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/v1k3ng_microservices)
# Readme homework #23


#### По grok использовал эти ресурсы
http://grokdebug.herokuapp.com/ - для тестирования паттернов
https://github.com/elastic/logstash/blob/v1.4.2/patterns/grok-patterns - мануал
https://github.com/fluent/fluent-plugin-grok-parser - мануал
https://docs.fluentd.org/configuration/config-file - мануал


# Readme homework #21

Репозиторий mad72 на Docker Hub
https://hub.docker.com/search?q=mad72&type=image


# Readme homework #20
Запустить проект
```
cd docker && docker-compose up -d
```


# Readme homework #19
Ссылка на slack-канал для проверки уведомлений от GitLab:
https://devops-team-otus.slack.com/messages/CH276EHPX


### Задание со * на странице 49

Разворачиваем инстансы Gitlab-CI и gitlab-runner
В файле **gitlab-ci/terraform/main.tf** для ресурса **gitlab-main-runner** нужно установить переменную **count** в то количество, какое нужно инстансов с раннерами. Также обратите внимание на необходимые шаблоны и файлы креденшлов в **gitlab-ci/ansible/gitlab-runner-standalone-install.yml**
```
terraform apply
```
Заходим на web-интсерфейс Gitlab-CI и запоминаем реквизиты для раннеров (адрес и ключ)
В файле **gitlab-ci/ansible/gitlab-runner-standalone-register.yml** нужно соответственно задать переменные **gitlab_i** и **gitlab_token**

Регистритруем раннеры
После работы terraform выведет список IP адресов для инстансов раннера.
С каждым из них нужно выполнить:
```
ansible-playbook -u appuser -i '<IP>,' --private-key ~/.ssh/appuser gitlab-runner-standalone-register.yml
```
Все, у нас есть нужное количество зарегистрированных раннеров в режиме autoscale. Т.е. под каждую job они будут создавать/удалять отдельный инстанс GCP согласно своим параметрам в файле **/etc/gitlab-runner/config.toml**



# Readme homework #17

**docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig** - запуск с параметром --network none (без сети, только loopback)

**docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig** - запуск с параметром --network host (сеть хостовой машины)

**docker network connect \<network\> \<container\>** - подключение дополнительных сетей к уже бегущему контейнеру

### Задание на странице 36
Можно в файле .env задать переменную COMPOSE_PROJECT_NAME в которой указать имя проекта. Это имя проекта станет префиксом для всех сущностей проекта. Кроме того, опытным путем выяснено, что перфикс зависит от имени директории, в которой находится docker-compose.yml.
Также можно указать ключ -p (--project-name) NAME и в нем указать нужное имя проекта.


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
