FROM python:2.7.16-alpine
MAINTAINER YoshimuraMakoto<ymlaedr@gmail.com>

ARG LOGIN_EMAIL
ARG LOGIN_PASSWORD

RUN apk \
  add \
  --update \
  --no-cache \
  --virtual .setup-util-dependencies \
    bash
RUN pip install --upgrade pip
RUN pip install gigalixir --ignore-installed six
RUN echo "PS1=\"\[\e[1;32m\]gigalixir_client\[\e[m\]$ \"" >> ~/.bashrc
ENTRYPOINT [ "/bin/bash", "-c", "gigalixir login -e ${LOGIN_EMAIL} -p ${LOGIN_PASSWORD} -y && /bin/bash", "--" ]
