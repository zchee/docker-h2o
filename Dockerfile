FROM zchee/buildpack-deps

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
COPY sysctl.conf /etc/

RUN mkdir -p /etc/h2o /var/run/h2o/ /var/log/h2o/
COPY h2o.conf /etc/h2o/
RUN touch /var/run/h2o/access-log /var/run/h2o/error-log

ENTRYPOINT ["h2o", "-c"]
CMD ["h2o", "-c", "/etc/h2o/h2o.conf"]
