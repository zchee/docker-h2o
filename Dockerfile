FROM buildpack-deps

RUN apt-get update && apt-get install -y --no-install-recommends \
      cmake && \
      rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/h2o/h2o && \
      cd h2o && \
      git submodule update --init --recursive && \
      cmake . && \
      make h2o

WORKDIR /h2o
COPY h2o.conf /h2o/
ENTRYPOINT ["./h2o", "-c"]
