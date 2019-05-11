FROM alpine:3.7

WORKDIR /app
ADD . /app

# RUN apk update && apk add gcc musl-dev && pip install --upgrade pip && pip install -r /app/requirements.txt 
RUN apk add --update --no-cache --virtual tmp gcc musl-dev python python-dev py-pip python3 python3-dev \
    && pip3 install --no-cache-dir -r /app/requirements.txt \
    && apk del tmp \
    && apk add --no-cache --virtual tmp python3

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

ENTRYPOINT ["python3", "post_app.py"]

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
