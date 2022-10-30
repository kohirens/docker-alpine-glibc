FROM alpine:3.16 AS base

ARG GLIBC_VER='2.35-r0'

#ENV LD_LIBRARY_PATH='/lib:/usr/lib:/usr/glibc-compat/lib:/usr/local/lib'

RUN apk --no-progress --purge --no-cache upgrade \
&& apk --no-progress --purge --no-cache add --upgrade --virtual=build_deps \
   ca-certificates \
   libstdc++ \
   gnupg \
&& apk --no-progress --purge --no-cache upgrade \
&& rm -vrf /var/cache/apk/*

# Install vanilla GLibC: https://github.com/sgerrand/alpine-pkg-glibc
WORKDIR "/tmp"

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk
RUN apk add --force-overwrite glibc-${GLIBC_VER}.apk glibc-bin-${GLIBC_VER}.apk glibc-i18n-${GLIBC_VER}.apk
RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
RUN rm -rf /tmp/*

CMD [ ]

FROM base AS dev

COPY start.sh /usr/local/bin/

# Install tools to help debug
RUN apk --no-progress --purge --no-cache upgrade \
 && apk --no-progress --purge --no-cache add --upgrade --virtual=build_deps \
    binutils \
 && apk --no-progress --purge --no-cache upgrade \
 && rm -vrf /var/cache/apk/* \
 && chmod a+x /usr/local/bin/start.sh

#RUN objdump -p /usr/lib/libstdc\+\+.so.6

ENTRYPOINT [ "start.sh" ]

FROM base AS release

ENTRYPOINT [ ]
