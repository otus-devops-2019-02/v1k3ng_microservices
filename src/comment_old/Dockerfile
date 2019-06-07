FROM alpine:3.7 AS first

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

ENV APP_HOME /app
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN apk add --update --no-cache --virtual tmp gcc make musl-dev ruby ruby-dev ruby-rdoc ruby-irb \
    && echo "gem: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && echo "install: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && echo "update: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && gem install --no-rdoc --no-ri --no-document bundler -v 1.17.2\
    && bundle install --no-cache \
    && gem cleanup \
    && apk del tmp \
    && apk add --update --no-cache ruby ruby-json \
    && cd / \
    && tar cvfj arch.tar \
        /etc/ssl \
        /lib/libcrypto.so.42.0.0 \
        /lib/libssl.so.44.0.1 \
        /usr/lib/ruby \
        /usr/lib/libruby.so.2.4.6 \
        /usr/lib/libgmp.so.10.3.2 \
        /usr/lib/libncursesw.so.6.0 \
        /usr/lib/libreadline.so.7.0 \
        /usr/lib/libyaml-0.so.2.0.5 \
        /usr/share/ca-certificates \
    && rm -rf /etc/ssl \
        /lib/libcrypto.so.42.0.0 \
        /lib/libssl.so.44.0.1 \
        /usr/lib/ruby \
        /usr/lib/libruby.so.2.4.6 \
        /usr/lib/libgmp.so.10.3.2 \
        /usr/lib/libncursesw.so.6.0 \
        /usr/lib/libreadline.so.7.0 \
        /usr/lib/libyaml-0.so.2.0.5 \
        /usr/share/ca-certificates \
    && rm -rf /root/.bundle \
        /usr/share/terminfo \
        /usr/lib/ruby/gems/2.4.0/cache \
        /lib/apk \
        /var/cache/* \
        /usr/share/apk \
        /sbin/apk \
        /usr/lib/ruby/vendor_ruby

ADD . $APP_HOME

CMD cd / \
    && tar xvf /arch.tar \
    && rm -rf /arch.tar \
    && cd /app \
    && puma

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
