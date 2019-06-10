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
RUN apk add --update --no-cache --virtual tmp gcc make musl-dev ruby ruby-dev ruby-rdoc ruby-irb tar \
    # && apk add --update --no-cache ruby-bundler \
    # rbenv install 2.4.6
    # && PATH=$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH \
    # && apk add --update --no-cache curl \
    # && apk add --update --no-cache bash \
    # && curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
    && echo "gem: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && echo "install: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && echo "update: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && gem install --no-rdoc --no-ri --no-document bundler -v 1.17.2 \
    && bundle install --no-cache \
    # && gem install bson_ext \
    # && gem install faraday \
    # && gem install haml \
    # && gem install prometheus-client \
    # && gem install puma \
    # && gem install rack -v 2.0.6 \
    # && gem install rufus-scheduler \
    # && gem install sinatra -v 2.0.2 \
    # && gem install sinatra-contrib \
    # && gem install tzinfo-data \
    # && gem install zipkin-tracer \
    # && gem install concurrent-ruby -v 1.1.4 \
    # && gem install concurrent-ruby -v 1.1.4 \
    # && gem install i18n -v 1.3.0 \
    # && gem install minitest -v 5.11.3 \
    # && gem install thread_safe -v 0.3.6 \
    # && gem install tzinfo -v 1.2.5 \
    # && gem install activesupport -v 5.2.2 \
    # && gem install backports -v 3.11.4 \
    # && gem install bson -v 1.12.5 \
    # && gem install bson_ext -v 1.12.5 \
    # && gem install et-orbi -v 1.1.6 \
    # && gem install multipart-post -v 2.0.0 \
    # && gem install faraday -v 0.15.4 \
    # && gem install thrift -v 0.9.3.0 \
    # && gem install finagle-thrift -v 1.4.2 \
    # && gem install raabro -v 1.1.6 \
    # && gem install fugit -v 1.1.6 \
    # && gem install temple -v 0.8.0 \
    # && gem install tilt -v 2.0.9 \
    # && gem install haml -v 5.0.4 \
    # && gem install multi_json -v 1.13.1 \
    # && gem install mustermann -v 1.0.3 \
    # && gem install quantile -v 0.2.1 \
    # && gem install prometheus-client -v 0.8.0 \
    # && gem install puma -v 3.12.0 \
    # && gem install rack -v 2.0.6 \
    # && gem install rack-protection -v 2.0.4 \
    # && gem install rufus-scheduler -v 3.5.2 \
    # && gem install sinatra -v 2.0.4 \
    # && gem install sinatra-contrib -v 2.0.4 \
    # && gem install sucker_punch -v 2.1.1 \
    # && gem install tzinfo-data -v 1.2018.7 \
    # && gem install zipkin-tracer -v 0.30.0 \
    && gem cleanup \
    && apk del tmp \
    # && apk add --update --no-cache ruby-rdoc \
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
    # && tar cvfj ssl.tar /etc/ssl && rm -rf /etc/ssl \
    # && tar cvfj libcrypto.tar /lib/libcrypto.so.42.0.0 /lib/libssl.so.44.0.1 \
    # && rm -rf /lib/libcrypto.so.42.0.0 /lib/libssl.so.44.0.1 \
    # && tar cvfj ruby.tar /usr/lib/ruby /usr/lib/libruby.so.2.4.6 /usr/lib/libgmp.so.10.3.2 /usr/lib/libncursesw.so.6.0 /usr/lib/libreadline.so.7.0 /usr/lib/libyaml-0.so.2.0.5 /usr/share/ca-certificates \
    # && rm -rf /usr/lib/ruby /usr/lib/libruby.so.2.4.6 /usr/lib/libgmp.so.10.3.2 /usr/lib/libncursesw.so.6.0 /usr/lib/libreadline.so.7.0 /usr/lib/libyaml-0.so.2.0.5 /usr/share/ca-certificates \
    # && tar cvfz bundle.tar /root/.bundle && rm -rf /root/.bundle \
    && rm -rf /root/.bundle \
        /usr/share/terminfo \
        /usr/lib/ruby/gems/2.4.0/cache \
        /lib/apk \
        /var/cache/* \
        /usr/share/apk \
        /sbin/apk \
        /usr/lib/ruby/vendor_ruby \
        /root/.gemrc


ADD . $APP_HOME
# ENTRYPOINT ["PATH=/root/.rbenv/bin:/root/.rbenv/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"]
# CMD ["puma"]
# CMD ["/bin/sh", "-c", \
#     "tar xvf /etc.tar /etc && rm -rf /etc.tar", \
#     "tar xvf /ssl.tar && rm -rf /ssl.tar", \
#     "tar xvf /libcrypto.tar && rm -rf /libcrypto.tar", \
#     "tar xvf /bundle.tar && rm -rf /bundle.tar", \ 
#     "tar xvf /ruby.tar && rm -rf /ruby.tar", \ 
#     "cd /app && puma"]
# CMD cd / tar xvf /ssl.tar && rm -rf /ssl.tar && tar xvf /libcrypto.tar && rm -rf /libcrypto.tar && tar xvf /bundle.tar && rm -rf /bundle.tar && tar xvf /ruby.tar && rm -rf /ruby.tar && cd /app && puma
# CMD cd / \
#     && tar xvf /ssl.tar \
#     && rm -rf /ssl.tar \
#     && tar xvf /libcrypto.tar \
#     && rm -rf /libcrypto.tar \
#     && tar xvf /ruby.tar \
#     && rm -rf /ruby.tar \
#     && cd /app \
#     && puma
CMD cd / \
    && tar xvf /arch.tar \
    && rm -rf /arch.tar \
    && cd /app \
    && puma

# FROM alpine:3.7
# ENV POST_SERVICE_HOST post
# ENV POST_SERVICE_PORT 5000
# ENV COMMENT_SERVICE_HOST comment
# ENV COMMENT_SERVICE_PORT 9292
# WORKDIR /
# COPY --from=first /arch.tar .
# WORKDIR /app
# CMD cd / \
#     && tar xvf /arch.tar \
#     && rm -rf /arch.tar \
#     && cd /app \
#     && puma

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
