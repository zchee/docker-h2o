# h2o

This is Dockerfile for trying [h2o](https://github.com/h2o/h2o).

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

