.PHONY: build_all push_all

USER = mad72

build_all: build_blackbox \
			build_cloudprober \
			build_mongodb_exporter \
			build_prometheus \
			build_comment \
			build_post-py \
			build_ui \
			build_grafana \
			build_cadvisor \
			build_alertmanager \
			build_trickster \
			build_telegraf \
			build_fluentd
	# docker build -t $(USER)/blackbox_exporter monitoring/blackbox_exporter/
	# docker build -t $(USER)/cloudprober monitoring/cloudprober/
	# docker build -t $(USER)/mongodb_exporter monitoring/mongodb_exporter/
	# docker build -t $(USER)/prometheus monitoring/prometheus/
	# docker build -t $(USER)/grafana monitoring/grafana/
	# docker build -t $(USER)/alertamanger monitoring/alertamanger/
	# docker build -t $(USER)/cadvisor monitoring/cadvisor/
	# docker build -t $(USER)/trickster monitoring/trickster/
	# docker build -t $(USER)/telegraf monitoring/telegraf/
	# export USER_NAME=mad72 && cd src/comment/ && bash docker_build.sh
	# export USER_NAME=mad72 && cd src/post-py/ && bash docker_build.sh
	# export USER_NAME=mad72 && cd src/ui/ && bash docker_build.sh

build_trickster: monitoring/trickster/Dockerfile
	docker build -t $(USER)/trickster monitoring/trickster/

build_telegraf: monitoring/telegraf/Dockerfile
	docker build -t $(USER)/telegraf monitoring/telegraf/

build_cadvisor: monitoring/cadvisor/Dockerfile
	docker build -t $(USER)/cadvisor monitoring/cadvisor/

build_grafana: monitoring/grafana/Dockerfile
	docker build -t $(USER)/grafana monitoring/grafana/

build_fluentd: logging/fluentd/Dockerfile
	docker build -t $(USER)/fluentd logging/fluentd/

build_alertmanager: monitoring/alertmanager/config.yml monitoring/alertmanager/Dockerfile
	docker build -t $(USER)/alertmanager monitoring/alertmanager/

build_blackbox: monitoring/blackbox_exporter/blackbox_exporter monitoring/blackbox_exporter/blackbox.yml monitoring/blackbox_exporter/Dockerfile
	docker build -t $(USER)/blackbox_exporter monitoring/blackbox_exporter/

build_cloudprober: monitoring/cloudprober/cloudprober.cfg monitoring/cloudprober/Dockerfile
	docker build -t $(USER)/cloudprober monitoring/cloudprober/

build_mongodb_exporter: monitoring/mongodb_exporter/mongodb_exporter monitoring/mongodb_exporter/Dockerfile
	docker build -t $(USER)/mongodb_exporter monitoring/mongodb_exporter/

build_prometheus: monitoring/prometheus/prometheus.yml monitoring/prometheus/Dockerfile
	docker build -t $(USER)/prometheus monitoring/prometheus/

build_comment: src/comment/comment_app.rb \
			src/comment/config.ru \
			src/comment/docker_build.sh \
			src/comment/Dockerfile \
			src/comment/Gemfile \
			src/comment/Gemfile.lock \
			src/comment/helpers.rb \
			src/comment/VERSION
	export USER_NAME=mad72 && cd src/comment/ && bash docker_build.sh

build_post-py: src/post-py/docker_build.sh \
			src/post-py/Dockerfile \
			src/post-py/helpers.py \
			src/post-py/post_app.py \
			src/post-py/requirements.txt \
			src/post-py/VERSION
	export USER_NAME=mad72 && cd src/post-py/ && bash docker_build.sh

build_ui: src/ui/config.ru \
			src/ui/docker_build.sh \
			src/ui/Dockerfile \
			src/ui/Gemfile \
			src/ui/Gemfile.lock \
			src/ui/helpers.rb \
			src/ui/middleware.rb \
			src/ui/ui_app.rb \
			src/ui/VERSION \
			src/ui/views/create.haml \
			src/ui/views/index.haml \
			src/ui/views/layout.haml \
			src/ui/views/show.haml
	export USER_NAME=mad72 && cd src/ui/ && bash docker_build.sh

push_all: push_blackbox \
			push_cloudprober \
			push_mongodb_exporter \
			push_prometheus \
			push_comment \
			push_post_py \
			push_ui \
			push_grafana \
			push_alertmanager \
			push_cadvisor \
			push_trickster \
			push_telegraf \
			push_fluentd
	# docker push $(USER)/blackbox_exporter:latest
	# docker push $(USER)/cloudprober:latest
	# docker push $(USER)/mongodb_exporter:latest
	# docker push $(USER)/prometheus:latest
	# docker push $(USER)/comment:latest
	# docker push $(USER)/post:latest
	# docker push $(USER)/ui:latest
	# docker push $(USER)/grafana:latest
	# docker push $(USER)/cadvisor:latest
	# docker push $(USER)/alertmanager:latest
	# docker push $(USER)/trickster:latest
	# docker push $(USER)/telegraf:latest

push_trickster: build_trickster
	docker push $(USER)/trickster:latest

push_fluentd: build_fluentd
	docker push $(USER)/fluentd:latest

push_telegraf: build_telegraf
	docker push $(USER)/telegraf:latest

push_cadvisor: build_cadvisor
	docker push $(USER)/cadvisor:latest

push_grafana: build_grafana
	docker push $(USER)/grafana:latest

push_alertmanager: build_alertmanager
	docker push $(USER)/alertmanager:latest

push_blackbox: build_blackbox
	docker push $(USER)/blackbox_exporter:latest

push_cloudprober: build_cloudprober
	docker push $(USER)/cloudprober:latest

push_mongodb_exporter: build_mongodb_exporter
	docker push $(USER)/mongodb_exporter:latest

push_prometheus: build_prometheus
	docker push $(USER)/prometheus:latest

push_comment: build_comment
	docker push $(USER)/comment:latest

push_post_py: build_post-py
	docker push $(USER)/post:latest

push_ui: build_ui
	docker push $(USER)/ui:latest
