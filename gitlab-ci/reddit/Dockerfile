FROM alpine:3.7 AS first


ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

ENV APP_HOME /app
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN apk add --update --no-cache --virtual tmp gcc make musl-dev ruby ruby-dev ruby-rdoc ruby-irb tar \
    && echo "gem: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && echo "install: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && echo "update: --no-rdoc --no-ri --no-document" >> /root/.gemrc \
    && gem install --no-rdoc --no-ri --no-document bundler -v 1.17.2 \
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

CMD cd / \
    && tar xvf /arch.tar \
    && rm -rf /arch.tar \
    && cd /app \
    && puma
