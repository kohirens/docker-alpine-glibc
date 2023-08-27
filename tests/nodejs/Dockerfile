ARG ALPINE_VER
ARG GLIBC_VER

FROM kohirens/alpine-glibc:dev-${ALPINE_VER}-${GLIBC_VER}

ARG NODE_VER
ARG NODE_DISTRO
ARG NODE_HOME

ENV SHELL=/bin/sh
# Node requires some version information to be present. It may be somewhere
# in the library chain it is missing. so you will see:
# $ node: /usr/lib/libstdc++.so.6: no version information available (required by node)

WORKDIR /tmp

RUN wget https://nodejs.org/dist/${NODE_VER}/node-${NODE_VER}-${NODE_DISTRO}.tar.xz \
 && mkdir -p "${NODE_HOME}" \
 && tar -vxf node-${NODE_VER}-${NODE_DISTRO}.tar.xz -C /usr/local/lib/nodejs \
 && rm -f node-${NODE_VER}-${NODE_DISTRO}.tar.xz

ENV PATH=${NODE_HOME}/node-${NODE_VER}-${NODE_DISTRO}/bin:${PATH}

RUN node --version
