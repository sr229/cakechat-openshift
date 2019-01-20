# Copyright 2019 (c) Capuccino
# Licensed Under MIT.

FROM alpine:latest

RUN apk add \
    git \
    build-base \
    python3 \
    python3-dev && \
    git clone https://github.com/lukalabs/cakechat /app --depth=10;

WORKDIR /app

RUN pip install -r requirements.txt && \
    python tools/download_model.py && \
    rm -rf .* && \
    rm -rf README.md;


RUN addgroup cakechat && \
    adduser -G cakechat -s /bin/sh -D cakechat;

COPY entrypoint /home/cakechat

RUN chgrp -R 0 /home/cakechat && \
    chmod a+x /home/cakechat/entrypoint && \
    chmod -R g=u /home/cakechat && \
    chmod g=u /etc/passwd && \
    apk del \
    git \
    build-base;

EXPOSE 8080

USER 10001

ENTRYPOINT ["/home/cakechat/entrypoint"]

CMD ["python", "/app/bin/cakechat_server.py"]