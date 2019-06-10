FROM alpine:3.7 AS first

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

WORKDIR /app
ADD . /app

RUN apk add --update --no-cache --virtual tmp gcc musl-dev python python-dev py-pip python3 python3-dev \
    && pip3 install --user --no-cache-dir -r /app/requirements.txt \
    && apk del tmp \
    && apk add --no-cache python3 \
    && cd / \
    && tar cvfj arch.tar \
        /etc/ssl \
        /lib/libcrypto.so.42.0.0 \
        /lib/libssl.so.44.0.1 \
        /root/.local \
        /usr/lib/python3.6 \
        /usr/lib/libpython3.6m.so.1.0 \
    && rm -rf /etc/ssl \
        /lib/libcrypto.so.42.0.0 \
        /lib/libssl.so.44.0.1 \
        /root/.local \
        /usr/lib/python3.6 \
        /usr/lib/libpython3.6m.so.1.0 \
    && rm -rf /usr/share/terminfo \
        /lib/apk \
        /var/cache/* \
        /usr/share/apk \
        /sbin/apk

CMD cd / \
    && tar xvf /arch.tar \
    && rm -rf /arch.tar \
    && cd /app \
    && python3 post_app.py


# # FROM python:3.6.0-alpine
# FROM python:2.7
# WORKDIR /app
# ADD requirements.txt /app
# RUN pip install -r requirements.txt
# ADD . /app
# EXPOSE  5000
# ENTRYPOINT ["python", "post_app.py"]
