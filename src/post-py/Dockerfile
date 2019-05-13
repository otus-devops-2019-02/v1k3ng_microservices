FROM alpine:3.7 AS first

WORKDIR /app
ADD . /app

RUN apk add --update --no-cache --virtual tmp gcc musl-dev python python-dev py-pip python3 python3-dev \
    && pip3 install --user --no-cache-dir -r /app/requirements.txt \
    && apk del tmp \
    && apk add --no-cache python3

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

ENTRYPOINT ["python3", "post_app.py"]

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
