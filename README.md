[![Build Status](https://travis-ci.com/otus-devops-2019-02/v1k3ng_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/v1k3ng_microservices)

# Readme homework #28

# Readme homework #27

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=<IP>"  
kubectl create secret tls ui-ingress --key tls.key --cert tls.crt -n dev  
kubectl describe secret ui-ingress -n dev  


https://kubernetes.io/docs/concepts/configuration/secret/ - мануал на офсайте
https://software.danielwatrous.com/generate-tls-secret-for-kubernetes/ - статья о секретах  
`kubectl get secret ui-ingress -o yaml` - вот так можно достать готовый yml

# Readme homework #26

Установка kubectl:
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version
```
Или
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl
```
Или
```
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```
Инструкция по установке Minikube для разных ОС:
https://kubernetes.io/docs/tasks/tools/install-minikube/

Обычно порядок конфигурирования kubectl следующий:
1) Создать cluster:
```
kubectl config set-cluster ... cluster_name
```
2) Создать данные пользователя (credentials):
```
kubectl config set-credentials ... user_name
```
3) Создать контекст:
```
kubectl config set-context context_name \
--cluster=cluster_name \
--user=user_name
```
4) Использовать контекст:
```
kubectl config use-context context_name
```
```
minikube service ui
minikube services list
minikube addons list
```

gcloud container clusters get-credentials k8s-cluster-for-asterisk

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy - ссылка на dashboard через kube proxy

kubectl -n kube-system edit service kubernetes-dashboard - таким образом можно редактировать живые сущности на лету. Офигенно.

https://github.com/kubernetes/dashboard/wiki/Creating-sample-user - про юзеров в k8s
kubectl -n kube-system describe rolebindings.rbac.authorization.k8s.io kubernetes-dashboard-minimal


# Readme homework #25

https://t.me/kubernetes_ru - русское сообщество Kubernetes в Telegram;
https://github.com/kelseyhightower/kubernetes-the-hard-way - курс от Kelsey Hightower;
https://www.katacoda.com/courses/kubernetes - Learn Kubernetes using Interactive Browser-Based Scenarios;
https://labs.play-with-k8s.com/ - A simple, interactive and fun playground to learn Kubernetes;
https://kubernetes.io/docs/reference/kubectl/cheatsheet/

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
