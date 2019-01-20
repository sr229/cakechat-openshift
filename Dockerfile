# Copyright 2019 (c) Capuccino
# Licensed Under MIT.

FROM python:3.6-stretch

RUN apt update && \
    apt -y install \
    git \
    unzip \
    build-essential \
    python3-dev 

RUN  mkdir -p /app && adduser --disabled-password --gecos '' cakechat && \
     chown -R cakechat:cakechat /app

WORKDIR /app

USER cakechat

RUN wget -q https://github.com/lukalabs/cakechat/archive/master.zip && \
    unzip master.zip -d . && \
    mv cakechat-master/* . && \
    rm -rf cakechat-master && \
    rm -rf master.zip;

USER root

RUN pip install  --compile -r requirements.txt

COPY entrypoint /home/cakechat
COPY run /app

RUN chgrp -R 0 /home/cakechat && \
    chmod a+x /home/cakechat/entrypoint && \
    chmod a+x /app/run && \
    chmod -R g=u /home/cakechat && \
    chmod g=u /etc/passwd && \
    apt purge -y \
    git \
    build-essential && \
    apt clean

RUN chmod g+rw /app && \
    chmod -R g=u /app;

EXPOSE 8080

USER cakechat

ENTRYPOINT ["/home/cakechat/entrypoint"]

CMD ["/app/run"]