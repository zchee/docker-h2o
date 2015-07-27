FROM buildpack-deps

RUN apt-get update && apt-get install -y --no-install-recommends \
      cmake && \
      rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/h2o/h2o --recursive && \
      cd h2o && \
      cmake . && \
      make h2o -j8

WORKDIR /h2o
COPY sysctl.conf /etc/
COPY h2o.conf /h2o/
ENTRYPOINT ["./h2o", "-c"]
