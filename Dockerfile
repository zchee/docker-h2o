FROM zchee/buildpack-deps

RUN apt-get update && apt-get install -y --no-install-recommends \
      cmake ninja-build && \
      rm -rf /var/lib/apt/lists/*

ENV MAKEFLAGS -j8

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
