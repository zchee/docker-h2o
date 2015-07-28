## h2o

This is Dockerfile for trying [h2o](https://github.com/h2o/h2o).

## Usage

To Build,

```bash
$ docker build -t zchee/h2o .
```

To run,

```bash
$ docker run --rm -p <port>:<port> zchee/h2o examples/h2o/h2o.conf
```

To custom config file run,

```bash
$ docker run --rm -p <port>:<port> zchee/h2o h2o.conf
```

## h2o.conf
Default h2o configure path: `/etc/h2o/h2o.conf`

Default configure, 

```conf
max-connections: 65536
limit-request-body: 536870912
num-threads: 16
num-name-resolution-threads: 1
http2-reprioritize-blocking-assets: ON
tcp-fastopen: 33554432

listen: 80
hosts:
  "127.0.0.1:80":
    paths:
      /:
        file.dir: examples/doc_root

listen: 8080
listen:
  port: 8081
  ssl:
    certificate-file: examples/h2o/server.crt
    key-file: examples/h2o/server.key
hosts:
  "127.0.0.1.xip.io:8080":
    paths:
      /:
        file.dir: examples/doc_root
    access-log: /dev/stdout
  "alternate.127.0.0.1.xip.io:8081":
    listen:
      port: 8081
      ssl:
        certificate-file: examples/h2o/alternate.crt
        key-file: examples/h2o/alternate.key
    paths:
      /:
        file.dir: examples/doc_root.alternate
    access-log: /dev/stdout
```

## sysctl.conf

[WIP] Default `/etc/sysctl.conf` is [https://klaver.it/linux/sysctl.conf](https://klaver.it/linux/sysctl.conf)  
It will refactoring later.

based, 
```conf
net.core.somaxconn=32768
net.core.netdev_max_backlog=32768
net.ipv4.tcp_max_syn_backlog=32768
net.ipv4.tcp_tw_recycle=1
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=10
net.core.rmem_max  = 16777216
net.core.wmem_max  = 16777216
net.ipv4.tcp_rmem  = 4096 349520 16777216
net.ipv4.tcp_wmem  = 4096 65536 16777216
net.ipv4.ip_local_port_range= 1024 65535
net.ipv4.tcp_timestamps = 0
```

## Installed packages

| Package         | Build              | Dockerfile                                                                    | Dependent |
|-----------------|--------------------|-------------------------------------------------------------------------------|-----------|
| libuv           | from source (HEAD) | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | h2o       |
| wslay           | from source (HEAD) | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | h2o       |
| mruby           | apt-get            | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | h2o       |
| libmruby        | apt-get            | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | h2o       |
| cmake           | apt-get            | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | h2o       |
| ninja           | apt-get            | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | h2o       |
| build-essential | apt-get            | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | *none*    |
| checkinstall    | apt-get            | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | wslay     |
| python-sphinx   | apt-get            | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | wslay     |
| libcunit1-dev   | apt-get            | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | wslay     |
| nettle-dev      | apt-get            | [zchee/docker-h2o](https://github.com/zchee/docker-h2o)                       | wslay     |
| apt-utils       | apt-get            | [zchee/docker-buildpack-deps](https://github.com/zchee/docker-buildpack-deps) | *none*    |
| locale          | apt-get            | [zchee/docker-buildpack-deps](https://github.com/zchee/docker-buildpack-deps) | *none*    |
