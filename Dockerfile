ARG ALPINE_VER="3.19"
ARG GLIBC_VER="2.39"
ARG PREFIX_DIR="/usr/glibc-compat"

FROM alpine:${ALPINE_VER} AS alpine-env

ARG USER_NAME
ARG USER_UID
ARG USER_GID
ARG USER_GROUP

ENV SHELL /bin/bash

WORKDIR /tmp

# gettext contains msgfmt, texinfo contains makeinfo
# make check fails with error about ctype.h which is part of musl-dev
RUN apk --no-progress --purge --no-cache upgrade \
 && apk --no-progress --purge --no-cache add --upgrade \
    bash \
    binutils \
    bison \
    gawk \
    gcc \
    gettext \
    git \
    grep \
    linux-headers \
    make \
    perl \
    python3 \
    texinfo \
 && apk --no-progress --purge --no-cache upgrade \
 && rm -vrf /var/cache/apk/* \
 && rm -rf /tmp/* \
 && git --version

# TODO: Try building gcc and makig libstdc++ to fix the nodejs version info warning.

# Build GlibC libssp dependency
# libssp-nonshared requires libc-dev
FROM alpine-env AS libssp

RUN apk --no-progress --purge --no-cache upgrade \
 && apk --no-progress --purge --no-cache add --upgrade \
    libc-dev \
 && apk --no-progress --purge --no-cache upgrade \
 && rm -vrf /var/cache/apk/* \
 && rm -rf /tmp/* \
 && cd /tmp \
 && git clone https://github.com/intc/libssp-nonshared \
 && cd libssp-nonshared \
 && ./configure \
 && make \
 && make install

FROM alpine-env AS build

ARG GLIBC_VER

COPY --from=libssp /usr/local/lib/libssp_nonshared.a /usr/local/lib

# Its way faster to use the tar over the git repo.
RUN wget https://ftp.gnu.org/gnu/glibc/glibc-"${GLIBC_VER}".tar.gz \
 && tar -xf glibc-"${GLIBC_VER}".tar.gz \
 && mv glibc-"${GLIBC_VER}" glibc

RUN mkdir -p /tmp/build/glibc \
 && cd /tmp/build/glibc \
 && /tmp/glibc/configure --prefix=/usr/glibc-"${GLIBC_VER}" --enable-stack-protector=strong --disable-werror \
 && make -r PARALLELMFLAGS="-j 2" > /tmp/make-glibc-"${GLIBC_VER}".log

RUN cd /tmp/build/glibc \
 && make install > /tmp/make-install-glibc-"${GLIBC_VER}".log

# Stop here to manually build when you need to troubleshoot.
COPY --chmod=0774 start.sh /usr/local/bin
ENTRYPOINT ["start.sh"]

FROM alpine:${ALPINE_VER} AS release

ARG GLIBC_VER

COPY --from=build /usr/glibc-"${GLIBC_VER}" /usr/glibc-"${GLIBC_VER}"
COPY --from=build "/usr/lib/libstdc++.so.6"  /usr/lib
COPY --from=build "/usr/lib/libstdc++.so.6.0.32"  /usr/lib
COPY --from=build "/usr/lib/libgcc_s.so.1"  /usr/lib

RUN ln -s /usr/glibc-"${GLIBC_VER}"/lib/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2 \
 && ln -s /usr/glibc-"${GLIBC_VER}"/etc/ld.so.cache /etc/ld.so.cache \
 && mkdir -p /lib64 \
 && ln -v -s -b -S .bak /usr/glibc-"${GLIBC_VER}"/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

# Allows existing libs and
ENV LD_LIBRARY_PATH=/lib:/usr/lib:/usr/glibc-"${GLIBC_VER}:${LD_LIBRARY_PATH}"

## Add the libc non-standard location to the path.
RUN echo "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
