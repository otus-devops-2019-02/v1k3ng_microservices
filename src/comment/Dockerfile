FROM alpine:3.7 AS first

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

ENV APP_HOME /app
# RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

# RUN apk add --update --no-cache --virtual tmp gcc make musl-dev ruby ruby-dev ruby-bundler ruby-rdoc ruby-irb \
#     && gem install bundler \
#     && bundle install --no-cache \
#     && bundle clean --force \
#     && apk del tmp \
#     && apk add --no-cache ruby-rdoc

RUN apk add --update --no-cache --virtual tmp gcc make musl-dev ruby ruby-dev ruby-rdoc ruby-irb \
    && echo "gem: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && echo "install: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && echo "update: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && gem install --no-rdoc --no-ri --no-document bundler -v 1.17.2\
    && bundle install --no-cache \
    && gem cleanup \
    && apk del tmp \
    && apk add --update --no-cache ruby ruby-json \
    && rm -rf /root/.bundle \
        /usr/share/terminfo \
        /usr/lib/ruby/gems/2.4.0/cache \
        /lib/apk \
        /var/cache/* \
        /usr/share/apk \
        /sbin/apk \
        /usr/lib/ruby/vendor_ruby

ADD . $APP_HOME
CMD ["puma"]

# FROM alpine:3.7
# ENV COMMENT_DATABASE_HOST comment_db
# ENV COMMENT_DATABASE comments
# COPY --from=first /app .
# COPY --from=first /root .
# WORKDIR /app
# RUN apk add --update --no-cache ruby-rdoc
# CMD ["puma"]

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
