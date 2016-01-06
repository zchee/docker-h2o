FROM buildpack-deps:jessie
MAINTAINER zchee <zchee.io@gmail.com>

# Set openssl arg and extra args
ARG H2O_EXTRA_ARGS
ARG LIBUV_EXTRA_ARGS
ARG WSLAY_EXTRA_ARGS

# Install libuv, wslay and h2o
# dependency packages
#  - h2o: cmake ninja-build mruby libmruby-dev
#  - wslay: build-essential checkinstall python-sphinx libcunit1-dev nettle-dev
RUN set -ex && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		cmake \
		ninja-build \
		mruby \
		libmruby-dev \
		checkinstall \
		python-sphinx \
		libcunit1-dev \
		nettle-dev && \
	rm -rf /var/lib/apt/lists/*

RUN git clone ${LIBUV_EXTRA_ARGS} https://github.com/libuv/libuv && \
		cd libuv && \
		sh autogen.sh && \
		./configure && \
		make -j$(nproc) && \
		make install && \
	git clone ${WSLAY_EXTRA_ARGS} https://github.com/tatsuhiro-t/wslay && \
		cd wslay && \
		cmake -G 'Ninja' . && \
		ninja && \
		ninja install && \
	git clone ${H2O_EXTRA_ARGS} https://github.com/h2o/h2o --recursive && \
		cd h2o && \
		cmake -G 'Ninja' -DWITH_BUNDLED_SSL=OFF . && \
		ninja && \
		ninja install

RUN mkdir -p /etc/h2o /var/run/h2o /var/log/h2o && \
	touch /var/run/h2o/access-log /var/run/h2o/error-log

COPY ./h2o.conf /etc/h2o

CMD ["/h2o/h2o", "-c", "/etc/h2o/h2o.conf"]
