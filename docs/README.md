# Docker Alpine GLibC

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
