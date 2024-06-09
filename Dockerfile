ARG ALPINE_VER="3.19"
ARG GLIBC_VER="2.39"

#FROM alpine:${ALPINE_VER} AS alpine-env
#
#ARG USER_NAME
#ARG USER_UID
#ARG USER_GID
#ARG USER_GROUP
#
#WORKDIR /tmp

## gettext contains msgfmt, texinfo contains makeinfo
## make check fails with error about ctype.h which is part of musl-dev
#RUN apk --no-progress --purge --no-cache upgrade \
# && apk --no-progress --purge --no-cache add --upgrade \
#    bash \
#    binutils \
#    bison \
#    gawk \
#    gcc \
#    gettext \
#    git \
#    grep \
#    linux-headers \
#    make \
#    perl \
#    python3 \
#    texinfo \
# && apk --no-progress --purge --no-cache upgrade \
# && rm -vrf /var/cache/apk/* \
# && rm -rf /tmp/* \
# && git --version
#
## TODO: Try building gcc and makig libstdc++ to fix the nodejs version info warning.
#
## Build GlibC libssp dependency
## libssp-nonshared requires libc-dev
#FROM alpine-env AS libssp
#
#RUN apk --no-progress --purge --no-cache upgrade \
# && apk --no-progress --purge --no-cache add --upgrade \
#    libc-dev \
# && apk --no-progress --purge --no-cache upgrade \
# && rm -vrf /var/cache/apk/* \
# && rm -rf /tmp/* \
# && cd /tmp \
# && git clone https://github.com/intc/libssp-nonshared \
# && cd libssp-nonshared \
# && ./configure \
# && make \
# && make install
#
#FROM alpine-env AS build
#
#ARG GLIBC_VER
#
#COPY --from=libssp /usr/local/lib/libssp_nonshared.a /usr/local/lib
#
## Its way faster to use the tar over the git repo.
#RUN wget https://ftp.gnu.org/gnu/glibc/glibc-"${GLIBC_VER}".tar.gz \
# && tar -xf glibc-"${GLIBC_VER}".tar.gz \
# && mv glibc-"${GLIBC_VER}" glibc
#
#RUN mkdir -p /tmp/build/glibc \
# && cd /tmp/build/glibc \
# && /tmp/glibc/configure --prefix=/usr/glibc-"${GLIBC_VER}" --enable-stack-protector=strong --disable-werror \
# && make -r PARALLELMFLAGS="-j 2" > /tmp/make-glibc-"${GLIBC_VER}".log
#
#RUN cd /tmp/build/glibc \
# && make install > /tmp/make-install-glibc-"${GLIBC_VER}".log
#
## Stop here to manually build when you need to troubleshoot.
#COPY --chmod=0774 start.sh /usr/local/bin
#ENTRYPOINT ["start.sh"]

FROM kohirens/alpine-glibc-build:${ALPINE_VER}-${GLIBC_VER} AS release
