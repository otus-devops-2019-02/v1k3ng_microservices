.PHONY: build_all_bugged push_all_bugged

USER = mad72

build_all_bugged: 	build_comment_bugged \
					build_post-py_bugged \
					build_ui_bugged

build_comment_bugged: comment/comment_app.rb \
			comment/config.ru \
			comment/docker_build.sh \
			comment/Dockerfile \
			comment/Gemfile \
			comment/Gemfile.lock \
			comment/helpers.rb \
			comment/VERSION
	export USER_NAME=mad72 && cd comment/ && bash docker_build.sh

build_post-py_bugged: post-py/docker_build.sh \
			post-py/Dockerfile \
			post-py/helpers.py \
			post-py/post_app.py \
			post-py/requirements.txt \
			post-py/VERSION
	export USER_NAME=mad72 && cd post-py/ && bash docker_build.sh

build_ui_bugged: ui/config.ru \
			ui/docker_build.sh \
			ui/Dockerfile \
			ui/Gemfile \
			ui/Gemfile.lock \
			ui/helpers.rb \
			ui/middleware.rb \
			ui/ui_app.rb \
			ui/VERSION \
			ui/views/create.haml \
			ui/views/index.haml \
			ui/views/layout.haml \
			ui/views/show.haml
	export USER_NAME=mad72 && cd ui/ && bash docker_build.sh

push_all_bugged: 	build_all_bugged
	docker push $(USER)/comment:bugged
	docker push $(USER)/post:bugged
	docker push $(USER)/ui:bugged

push_comment_bugged: build_comment_bugged
	docker push $(USER)/comment:bugged

push_post_py_bugged: build_post-py_bugged
	docker push $(USER)/post:bugged

push_ui_bugged: build_ui_bugged
	docker push $(USER)/ui:bugged
