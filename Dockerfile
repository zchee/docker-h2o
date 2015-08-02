FROM buildpack-deps:jessie
MAINTAINER zchee <zcheeee@gmail.com>

# set noninteractive
ENV DEBIAN_FRONTEND noninteractive
# sed to cdn server for apt source url
RUN sed -i 's/httpredir.debian.org/cdn.debian.net/' /etc/apt/sources.list
# apt-get update use cdn server
RUN apt-get update
# set locale
RUN apt-get install -y --no-install-recommends apt-utils locales
ENV LANG en_US.UTF-8
RUN echo $LANG UTF-8 > /etc/locale.gen
RUN locale-gen
RUN update-locale LANG=$LANG
ENV LC_ALL C
ENV LC_ALL $LANG

WORKDIR /
ENV MAKEFLAGS -j8

# Install cmake, ninja, and dependency h2o packages
# h2o: cmake ninja-build mruby libmruby-dev
# wslay: build-essential checkinstall python-sphinx libcunit1-dev nettle-dev
RUN apt-get update && apt-get install -y --no-install-recommends \
      cmake ninja-build mruby libmruby-dev build-essential checkinstall python-sphinx libcunit1-dev nettle-dev && \
      rm -rf /var/lib/apt/lists/*

# Install libuv
RUN git clone https://github.com/libuv/libuv && \
      cd libuv && \
      sh autogen.sh && \
      ./configure && \
      make && \
      make install

# Installl wslay
RUN git clone https://github.com/tatsuhiro-t/wslay && \
      cd wslay && \
      autoreconf -i && \
      automake && \
      autoconf && \
      ./configure && \
      make && \
      make install

# Install h2o use ninja
RUN git clone https://github.com/h2o/h2o --recursive && \
      cd h2o && \
      cmake -G 'Ninja' -DWITH_BUNDLED_SSL=off . && \
      ninja && \
      ninja install

WORKDIR /h2o

RUN mkdir -p /etc/h2o /var/run/h2o/ /var/log/h2o/
COPY h2o.conf /etc/h2o/
RUN touch /var/run/h2o/access-log /var/run/h2o/error-log

CMD ["h2o", "-c", "/etc/h2o/h2o.conf"]
