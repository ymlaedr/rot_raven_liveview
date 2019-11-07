FROM elixir:1.9.2-alpine as builder
MAINTAINER YoshimuraMakoto<ymlaedr@gmail.com>

ENV LANG C.UTF-8
ENV ENTRYKIT_VERSION 0.4.0

WORKDIR /root

RUN apk \
      add \
      --update \
      --no-cache \
      --virtual .setup-timezone-dependencies \
        tzdata

RUN apk \
      add \
      --update \
      --no-cache \
      --virtual .setup-entrykit-dependencies \
        ca-certificates \
        curl \
        openssl

## EntryKitの取得
RUN update-ca-certificates \
 && curl -o entrykit.tgz -L https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz



FROM elixir:1.9.2-alpine as dev
MAINTAINER YoshimuraMakoto<ymlaedr@gmail.com>

RUN apk \
      add \
      --update \
      --no-cache \
      --virtual execute-phoenix-livereload-dependencies \
        inotify-tools

RUN apk \
      add \
      --update \
      --no-cache \
      --virtual \
        git

# phoenixのセットアップ
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new --force

WORKDIR /root

## タイムゾーンを変更
COPY --from=builder /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

## entrykitのセットアップ
COPY --from=builder /root/entrykit.tgz /root
RUN tar -zxvf entrykit.tgz \
 && mv entrykit /bin/entrykit \  
 && chmod +x /bin/entrykit \
 && entrykit --symlink


