FROM alpine:3.7 AS first


ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

# RUN apk add --update --no-cache --virtual tmp gcc make musl-dev ruby ruby-dev ruby-bundler ruby-rdoc ruby-irb \
#     && gem install --no-rdoc bundler \
#     && bundle install --no-cache \
#     && bundle clean --force \
#     && apk del tmp \    
#     && apk add --update --no-cache ruby-rdoc

RUN apk add --update --no-cache --virtual tmp gcc make musl-dev ruby ruby-dev ruby-rdoc ruby-irb \
    && PATH=$PATH:/root/.gem/ruby/2.4.0/bin \
    && gem install --no-rdoc --user-install bundler \
    && bundle install --no-cache \
    && bundle clean --force 
    # && apk del tmp \
    # && apk add --update --no-cache ruby-rdoc

ADD . $APP_HOME

# CMD ["puma"]


FROM alpine:3.7
ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292
COPY --from=first /app /
COPY --from=first /root /
RUN apk add --update --no-cache ruby \
    && PATH=$PATH:/root/.gem/ruby/2.4.0/bin
CMD ["puma"]

# FROM ruby:2.2

# RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list \
#     && apt update -qq \
#     && apt install -y build-essential \
#     && apt-get clean

# ENV APP_HOME /app
# RUN mkdir $APP_HOME

# WORKDIR $APP_HOME
# ADD Gemfile* $APP_HOME/
# RUN bundle install
# ADD . $APP_HOME

# ENV POST_SERVICE_HOST post
# ENV POST_SERVICE_PORT 5000
# ENV COMMENT_SERVICE_HOST comment
# ENV COMMENT_SERVICE_PORT 9292

# CMD ["puma"]
