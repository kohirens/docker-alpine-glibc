ARG ALPINE_VER
ARG GLIBC_VER

FROM kohirens/alpine-glibc:dev-${ALPINE_VER}-${GLIBC_VER}

ENV SHELL=/bin/sh

WORKDIR /tmp

RUN apk --no-progress --purge --no-cache upgrade \
 && apk --no-progress --purge --no-cache add --upgrade \
    gnupg \
    gzip \
    zip \
 && apk --no-progress --purge --no-cache upgrade \
 && rm -vrf /var/cache/apk/* \
 && rm -rf /tmp/*

RUN wget  -O "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
 && unzip awscliv2.zip

RUN ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli \
 && aws --version
