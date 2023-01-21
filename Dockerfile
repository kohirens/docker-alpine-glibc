ARG ALPINE_VER
ARG GLIBC_VER

FROM alpine:${ALPINE_VER} AS release

ARG GLIBC_VER

RUN apk --no-progress --purge --no-cache upgrade \
&& apk --no-progress --purge --no-cache add --upgrade --virtual=build_deps \
   gnupg \
   libstdc++ \
&& apk --no-progress --purge --no-cache upgrade \
&& rm -vrf /var/cache/apk/*

# Install vanilla GLibC: https://github.com/sgerrand/alpine-pkg-glibc
WORKDIR "/tmp"

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk \
 && apk add --force-overwrite glibc-${GLIBC_VER}.apk glibc-bin-${GLIBC_VER}.apk glibc-i18n-${GLIBC_VER}.apk \
 && rm -vrf /var/cache/apk/* \
 && rm -rf /tmp/*
RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8

ENTRYPOINT [ ]

CMD [ ]

FROM release AS dev

COPY start.sh /usr/local/bin/

# Install tools to help debug
RUN apk --no-progress --purge --no-cache upgrade \
 && apk --no-progress --purge --no-cache add --upgrade --virtual=build_deps \
    binutils \
 && apk --no-progress --purge --no-cache upgrade \
 && rm -vrf /var/cache/apk/* \
 && chmod a+x /usr/local/bin/start.sh

#RUN objdump -p /usr/lib/libstdc\+\+.so.6

# For testing we can insall node and see if it gives the version without error.
# Currently node is not working with sgerrand/alpine-pkg-glibc.
# There seems to be symbols (maybe functions) missing.
# It will work if you:
# $ apk --force-overwrite add libc6-compat gcompat
# However you will see output like:
# $ node: /usr/lib/libstdc++.so.6: no version information available (required by node)
ENV NODE_VER="v18.13.0"
ENV NODE_DISTRO="linux-x64"
ENV NODE_HOME="/usr/local/lib/nodejs"

RUN cd /tmp \
 && wget https://nodejs.org/dist/v18.13.0/node-${NODE_VER}-${NODE_DISTRO}.tar.xz \
 && mkdir -p "${NODE_HOME}" \
 && tar -vxf node-${NODE_VER}-${NODE_DISTRO}.tar.xz -C /usr/local/lib/nodejs \
 && rm -f node-${NODE_VER}-${NODE_DISTRO}.tar.xz

ENV PATH=${NODE_HOME}/node-${NODE_VER}-${NODE_DISTRO}/bin:${PATH}

ENTRYPOINT [ "start.sh" ]
