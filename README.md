# Alpine GLIBC

Uses vanilla GLibC from: https://github.com/sgerrand/alpine-pkg-glibc

NOTE: When you run any app that uses the glibc you will get a info message
output. You can ignore these for now, they are caused by a dependency that is
in pre-release mode. I do not believe this is caused by the GLibC files
themselves, but an external dependency from the Alpine repos that is in
pre-release mode.

I dug into this and found the cause, but forgot to record them in my notes.
I Will need to dig into this again to verify the exact dependency that causes
this.

## Build

To build the docker image based on a version of GlibC, run:

```shell
$Env:GLIBC_VER="2.35-r0"; docker compose build --progress plain
```
