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

COPY public-gpg-key ./public-gpg-key

RUN wget -O "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
 && gpg --import public-gpg-key \
 && wget -O awscliv2.sig https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig \
 && gpg --verify awscliv2.sig awscliv2.zip \
 && unzip -q awscliv2.zip

RUN ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli
RUN aws --version
