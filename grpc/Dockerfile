FROM debian:stretch-slim AS builder
MAINTAINER YoshimuraMakoto<ymlaedr@gmail.com>

WORKDIR /root

RUN apt update \
 && apt install -y \
  autoconf \
  automake \
  curl \
  git \
  g++ \
  libtool \
  make \
  unzip \
  wget

RUN wget \
  -O /root/protoc-gen-grpc-web \
  https://github.com/grpc/grpc-web/releases/download/1.0.6/protoc-gen-grpc-web-1.0.6-linux-x86_64
RUN wget \
  -O /root/mix_deps_add.ez \
  https://github.com/bryanstearns/mix_deps_add/releases/download/0.1.3/mix_deps_add-0.1.3.ez

RUN git clone https://github.com/protocolbuffers/protobuf.git \
 && cd protobuf \
 && git submodule update --init --recursive \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make check \
 && make install \
 && ldconfig

FROM elixir:1.8.2-slim AS runner

COPY --from=builder /usr/local/bin/protoc /usr/local/bin/
COPY --from=builder /usr/local/lib/libprotobuf.so.20 /usr/local/lib/

COPY --from=builder /usr/local/lib/libprotoc.so.20 /usr/local/lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/
COPY --from=builder /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/
COPY --from=builder /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/
COPY --from=builder /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/
COPY --from=builder /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/
COPY --from=builder /lib64/ld-linux-x86-64.so.2 /lib64/

COPY --from=builder /root/protoc-gen-grpc-web /usr/local/bin/
COPY --from=builder /root/mix_deps_add.ez /root/

RUN chmod +x /usr/local/bin/protoc-gen-grpc-web

RUN mix local.hex --force \
 && mix local.rebar --force \
 && mix escript.install hex protobuf --force \
 && mix archive.install --force /root/mix_deps_add.ez && rm /root/mix_deps_add.ez

ENV PATH $PATH:/root/.mix/escripts
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib
