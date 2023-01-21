# Alpine GLIBC

For Docker image tags see [kohirens/alpine-glibc]

Uses vanilla GLibC from: https://github.com/sgerrand/alpine-pkg-glibc

NOTE: When you run any app that uses the glibc you will get a info message
output. You can ignore these for now, they are caused by a dependency that is
in pre-release mode. I do not believe this is caused by the GLibC files
themselves, but an external dependency from the Alpine repos that is in
pre-release mode.

I dug into this and found the cause, but forgot to record them in my notes.
I Will need to dig into this again to verify the exact dependency that causes
this.

## Status

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/kohirens/docker-alpine-glibc/tree/main.svg?style=shield&&circle-token=)](https://dl.circleci.com/status-badge/redirect/gh/kohirens/docker-alpine-glibc/tree/main)

## Build

To build the development image for testing a version of GlibC, run:

```shell
docker compose build
```

or without Docker Compose installed

```shell
docker build -t "kohirens/alpine-glibc:release" --build-arg "ALPINE_VER=3.17" --build-arg "GLIBC_VER=2.35-r0" --target "release" .
```

## Test

Running this will allow you to look around the container. The GlibC files will
have been places in `/usr/glibc-compat`

```shell
docker run -it --rm --entrypoint "" "kohirens/alpine-glibc:release"
```

## About GlibC Files

The GlibC package will install files in `/usr/glibc-compat`, such as:

```text
bin
etc
lib
lib64
sbin
share
```
You may have to update certain environment variable so that they are used. For
example, setting LD_LIBRARY_PATH='/usr/glibc-compat/lib'
before you build a GLibC dependent application.

---

[kohirens/alpine-glibc]: https://hub.docker.com/repository/docker/kohirens/alpine-glibc
