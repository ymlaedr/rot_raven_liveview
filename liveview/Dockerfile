FROM elixir:1.9.2-alpine
MAINTAINER YoshimuraMakoto<ymlaedr@gmail.com>

WORKDIR /root/liveview

RUN apk add --update \
  git \
  inotify-tools \
  nodejs \
  nodejs-npm

RUN mix local.hex --force
RUN mix archive.install hex phx_new --force
RUN mix local.rebar --force
