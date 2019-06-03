USER = mad72

build_all: build_blackbox \
			build_cloudprober \
			build_mongodb_exporter \
			build_prometheus \
			build_comment \
			build_post-py \
			build_ui
	docker build -t $(USER)/blackbox_exporter monitoring/blackbox_exporter/
	docker build -t $(USER)/cloudprober monitoring/cloudprober/
	docker build -t $(USER)/mongodb_exporter monitoring/mongodb_exporter/
	docker build -t $(USER)/prometheus monitoring/prometheus/
	export USER_NAME=mad72 && cd src/comment/ && bash docker_build.sh
	export USER_NAME=mad72 && cd src/post-py/ && bash docker_build.sh
	export USER_NAME=mad72 && cd src/post-py/ && bash docker_build.sh

build_blackbox: monitoring/blackbox_exporter/blackbox_exporter monitoring/blackbox_exporter/blackbox.yml monitoring/blackbox_exporter/Dockerfile
	docker build -t $(USER)/blackbox_exporter monitoring/blackbox_exporter/

build_cloudprober: monitoring/cloudprober/cloudprober.cfg monitoring/cloudprober/Dockerfile
	docker build -t $(USER)/cloudprober monitoring/cloudprober/

build_mongodb_exporter: monitoring/mongodb_exporter/mongodb_exporter monitoring/mongodb_exporter/Dockerfile
	docker build -t $(USER)/mongodb_exporter monitoring/mongodb_exporter/

build_prometheus: monitoring/prometheus/prometheus.yml monitoring/prometheus/Dockerfile
	docker build -t $(USER)/prometheus monitoring/prometheus/

build_comment: src/comment/build_info.txt \
			src/comment/comment_app.rb \
			src/comment/config.ru \
			src/comment/docker_build.sh \
			src/comment/Dockerfile \
			src/comment/Gemfile \
			src/comment/Gemfile.lock \
			src/comment/helpers.rb \
			src/comment/VERSION
	export USER_NAME=mad72 && cd src/comment/ && bash docker_build.sh

build_post-py: src/post-py/build_info.txt \
			src/post-py/docker_build.sh \
			src/post-py/Dockerfile \
			src/post-py/helpers.py \
			src/post-py/post_app.py \
			src/post-py/requirements.txt \
			src/post-py/VERSION
	export USER_NAME=mad72 && cd src/post-py/ && bash docker_build.sh

build_ui: src/ui/build_info.txt \
			src/ui/config.ru \
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
			push_ui
	docker push $(USER)/blackbox_exporter:latest
	docker push $(USER)/cloudprober:latest
	docker push $(USER)/mongodb_exporter:latest
	docker push $(USER)/prometheus:latest
	docker push $(USER)/comment:latest
	docker push $(USER)/post:latest
	docker push $(USER)/ui:latest

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