# Docker Alpine GLibC

Uses vanilla GLibC from: https://github.com/sgerrand/alpine-pkg-glibc

NOTICE: This is vanilla GLibC and some older deprecated functions may not
be available. So when you run any app that uses the glibc, then you may
get info messages output. You may ignore these if your app continues to pass
all of its test.

Testing is critical before taking your app to production.

## Status

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/kohirens/docker-alpine-glibc/tree/main.svg?style=shield&&circle-token=)](https://dl.circleci.com/status-badge/redirect/gh/kohirens/docker-alpine-glibc/tree/main)

## Features

See [The GNU C Library version 2.35 is now available].

## Usage

This image is meant to be base of another Alpine image that requires GLibC.

For example

```Docker
FROM kohirens/alpine-glibc AS base

RUN ...
```

For Docker image tags see [kohirens/alpine-glibc]

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
[The GNU C Library version 2.35 is now available]: https://sourceware.org/pipermail/libc-alpha/2022-February/136040.html
