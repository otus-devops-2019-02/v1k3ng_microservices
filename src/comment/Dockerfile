FROM alpine:3.7

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN apk add --update --no-cache --virtual tmp gcc make musl-dev ruby ruby-dev ruby-bundler ruby-rdoc ruby-irb \
    && gem install bundler \
    && bundle install --no-cache \
    && bundle clean --force \
    && apk del tmp \
    && apk add --no-cache ruby-rdoc

ADD . $APP_HOME
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

# ENV COMMENT_DATABASE_HOST comment_db
# ENV COMMENT_DATABASE comments

# CMD ["puma"]
