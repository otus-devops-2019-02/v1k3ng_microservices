FROM alpine:3.7 AS first


ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292
# ENV PATH=/app/ruby/2.4.0/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV APP_HOME /app
# RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

# RUN apk add --update --no-cache --virtual tmp gcc make musl-dev ruby ruby-dev ruby-rdoc ruby-irb \
#     && gem install --no-rdoc bundler \
#     && bundle install --no-cache \
#     && bundle clean --force \
#     && apk del tmp \    
#     && apk add --update --no-cache ruby-rdoc

# RUN apk add --update --no-cache gcc make libc-dev git curl bash musl-dev openssl-dev readline-dev \
RUN apk add --update --no-cache --virtual tmp gcc make musl-dev ruby ruby-dev ruby-rdoc ruby-irb \
    # && apk add --update --no-cache ruby-bundler \
    # rbenv install 2.4.6
    # && PATH=$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH \
    # && apk add --update --no-cache curl \
    # && apk add --update --no-cache bash \
    # && curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
    && echo "gem: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && echo "install: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && echo "update: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && gem install --no-rdoc --no-ri --no-document bundler -v 1.17.2\
    && bundle install --no-cache \
    # && gem install sinatra -v 2.0.2 \
    # && gem install sinatra-contrib \
    # && gem install haml \
    # && gem install bson_ext \
    # && gem install faraday \
    # && gem install puma \
    # && gem install prometheus-client \
    # && gem install rack -v 2.0.6 \
    # && gem install rufus-scheduler \
    # && gem install tzinfo-data \
    # && gem install zipkin-tracer \
    # && gem install concurrent-ruby -v 1.1.4 \
    && gem cleanup \
    && apk del tmp \
    # && apk add --update --no-cache ruby-rdoc \
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
# ENTRYPOINT ["PATH=/root/.rbenv/bin:/root/.rbenv/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"]
CMD ["puma"]


# FROM alpine:3.7
# ENV POST_SERVICE_HOST post
# ENV POST_SERVICE_PORT 5000
# ENV COMMENT_SERVICE_HOST comment
# ENV COMMENT_SERVICE_PORT 9292
# WORKDIR /root
# COPY --from=first /root .
# WORKDIR /app
# COPY --from=first /app .
# RUN apk add --update --no-cache ruby \
#     && PATH=$PATH:/root/.gem/ruby/2.4.0/bin
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

# ENV POST_SERVICE_HOST post
# ENV POST_SERVICE_PORT 5000
# ENV COMMENT_SERVICE_HOST comment
# ENV COMMENT_SERVICE_PORT 9292

# CMD ["puma"]
