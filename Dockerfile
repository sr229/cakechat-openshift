# Copyright 2019 (c) Capuccino
# Licensed Under MIT.

FROM python:3.6-stretch

RUN apt update && \
    apt -y install \
    git \
    build-essential \
    python3-dev && \
    git clone https://github.com/lukalabs/cakechat /app --depth=10;

WORKDIR /app

RUN rm -rf README.md;


RUN pip install  --compile -r requirements.txt && \ 
    adduser --disabled-password --gecos '' cakechat


COPY entrypoint /home/cakechat

RUN chgrp -R 0 /home/cakechat && \
    chmod a+x /home/cakechat/entrypoint && \
    chmod -R g=u /home/cakechat && \
    chmod g=u /etc/passwd && \
    apt purge -y \
    git \
    build-essential && \
    apt clean

RUN chown -R cakechat:cakechat /app/* && \
    chmod g+rw /app;

EXPOSE 8080

USER 10001

ENTRYPOINT ["/home/cakechat/entrypoint"]

CMD ["python", "tools/download_model.py", "&&", "python", "/app/bin/cakechat_server.py"]