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
    # && tar cvfj ssl.tar /etc/ssl && rm -rf /etc/ssl \
    # && tar cvfj libcrypto.tar /lib/libcrypto.so.42.0.0 /lib/libssl.so.44.0.1 \
    # && rm -rf /lib/libcrypto.so.42.0.0 /lib/libssl.so.44.0.1 \
    # && tar cvfj root.tar /root/.local && rm -rf /root/.local \
    # && tar cvfj python.tar /usr/lib/python3.6 /usr/lib/libpython3.6m.so.1.0 && rm -rf /usr/lib/python3.6 /usr/lib/libpython3.6m.so.1.0 \
    && rm -rf /usr/share/terminfo \
        /lib/apk \
        /var/cache/* \
        /usr/share/apk \
        /sbin/apk 

# ENTRYPOINT ["python3", "post_app.py"]
# CMD cd / \
#     && tar xvf /ssl.tar \
#     && rm -rf /ssl.tar \
#     && tar xvf /libcrypto.tar \
#     && rm -rf /libcrypto.tar \
#     && tar xvf /root.tar \
#     && rm -rf /root.tar \
#     && tar xvf /python.tar \
#     && rm -rf /python.tar \
#     && cd /app \
#     && python3 post_app.py
CMD cd / \
    && tar xvf /arch.tar \
    && rm -rf /arch.tar \
    && cd /app \
    && python3 post_app.py


# FROM alpine:3.7
# ENV POST_DATABASE_HOST post_db
# ENV POST_DATABASE posts
# COPY --from=0 /app .
# COPY --from=0 /root .
# RUN apk add --no-cache python3
# ENTRYPOINT ["python3", "post_app.py"]

# FROM python:3.6.0-alpine

# WORKDIR /app
# ADD . /app

# # RUN apk update && apk add gcc musl-dev && pip install --upgrade pip && pip install -r /app/requirements.txt 
# RUN apk update \
#     && apk add --no-cache --virtual tmp gcc musl-dev \
#     && pip install --no-cache-dir --upgrade pip \
#     && pip install --no-cache-dir -r /app/requirements.txt \
#     && apk del tmp

# ENV POST_DATABASE_HOST post_db
# ENV POST_DATABASE posts

# ENTRYPOINT ["python3", "post_app.py"]
