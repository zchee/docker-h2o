FROM buildpack-deps:jessie
MAINTAINER zchee <zchee.io@gmail.com>

# set noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV MAKEFLAGS -j8
# sed to cdn server for apt source url
RUN sed -i 's/httpredir.debian.org/cdn.debian.net/' /etc/apt/sources.list

WORKDIR /

# Install cmake, ninja, and dependency h2o packages
# h2o: cmake ninja-build mruby libmruby-dev
# wslay: build-essential checkinstall python-sphinx libcunit1-dev nettle-dev
RUN apt-get update && apt-get install -y --no-install-recommends \
      cmake ninja-build mruby libmruby-dev build-essential checkinstall python-sphinx libcunit1-dev nettle-dev && \
      rm -rf /var/lib/apt/lists/*

# Install libuv
ARG LIBUV_EXTRA_ARGS
RUN git clone ${LIBUV_EXTRA_ARGS} https://github.com/libuv/libuv && \
      cd libuv && \
      sh autogen.sh && \
      ./configure && \
      make && \
      make install

# Installl wslay
ARG WSLAY_EXTRA_ARGS
RUN git clone ${WSLAY_EXTRA_ARGS} https://github.com/tatsuhiro-t/wslay && \
      cd wslay && \
      autoreconf -i && \
      automake && \
      autoconf && \
      ./configure && \
      make && \
      make install

# Install h2o use ninja
ARG H2O_EXTRA_ARGS
RUN git clone ${H2O_EXTRA_ARGS} https://github.com/h2o/h2o --recursive && \
      cd h2o && \
      cmake -G 'Ninja' -DWITH_BUNDLED_SSL=off . && \
      ninja && \
      ninja install

WORKDIR /h2o

RUN mkdir -p /etc/h2o /var/run/h2o/ /var/log/h2o/
COPY h2o.conf /etc/h2o/
RUN touch /var/run/h2o/access-log /var/run/h2o/error-log

CMD ["h2o", "-c", "/etc/h2o/h2o.conf"]
