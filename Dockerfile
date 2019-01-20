# Copyright 2019 (c) Capuccino
# Licensed Under MIT.

FROM alpine:latest

RUN apk add \
    git \
    build-base \
    python3 \
    python3-dev \
    libffi-dev openssl-dev  && \
    pip3 install pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [ ! -e /usr/bin/python ]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
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
    build-base \
    libffi-dev \
    openssl-dev \
    python3-dev;

EXPOSE 8080

USER 10001

ENTRYPOINT ["/home/cakechat/entrypoint"]

CMD ["python", "/app/bin/cakechat_server.py"]