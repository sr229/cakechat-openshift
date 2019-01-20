# Copyright 2019 (c) Capuccino
# Licensed Under MIT.

FROM debian:latest

RUN apt -y install \
    git \
    build-essential \
    python3 \
    python3-pip \
    python3-dev \
    libffi-dev openssl-dev  && \
    apt remove -y python && \
    pip3 install pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [ ! -e /usr/bin/python ]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    git clone https://github.com/lukalabs/cakechat /app --depth=10;

WORKDIR /app

RUN pip install -r requirements.txt && \
    python tools/download_model.py && \
    rm -rf .* && \
    rm -rf README.md;


RUN adduser --disabled-password --gecos '' cakechat


COPY entrypoint /home/cakechat

RUN chgrp -R 0 /home/cakechat && \
    chmod a+x /home/cakechat/entrypoint && \
    chmod -R g=u /home/cakechat && \
    chmod g=u /etc/passwd && \
    apt purge -y \
    git \
    build-essential \
    libffi-dev \
    openssl-dev \
    python3-dev;

EXPOSE 8080

USER 10001

ENTRYPOINT ["/home/cakechat/entrypoint"]

CMD ["python", "/app/bin/cakechat_server.py"]