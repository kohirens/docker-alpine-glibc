ARG ALPINE_VER=3.18
ARG GLIBC_VER=2.35-r1

FROM alpine:${ALPINE_VER} AS release

ARG GLIBC_VER

#ENV LD_LIBRARY_PATH='/usr/glibc-compat/lib'

RUN apk --no-progress --purge --no-cache upgrade \
&& apk --no-progress --purge --no-cache add --upgrade --virtual=build_deps \
   libstdc++ \
&& apk --no-progress --purge --no-cache upgrade \
&& rm -vrf /var/cache/apk/*

# Install vanilla GLibC: https://github.com/sgerrand/alpine-pkg-glibc
WORKDIR /tmp

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
 && apk add --force-overwrite glibc-${GLIBC_VER}.apk

RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk \
 && apk add --force-overwrite glibc-bin-${GLIBC_VER}.apk glibc-i18n-${GLIBC_VER}.apk

# Patch - Vanilla GlibC link lib64 libs again.
RUN ln -v -s -b -S .bak /usr/glibc-compat/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

# Cleanup
RUN rm -vrf /var/cache/apk/* \
 && rm -rf /tmp/* \
 && rm /etc/apk/keys/sgerrand.rsa.pub

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

RUN objdump -p /usr/lib/libstdc\+\+.so.6

# For details see: https://man7.org/linux/man-pages/man1/localedef.1.html
RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
#ENV LANG='C.UTF-8'
#RUN echo "export LANG=${LANG}" > /etc/profile.d/locale.sh
#RUN /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap C.UTF-8 "${LANG}"

# For testing we can insall node and see if it gives the version without error.
# Currently node is not working with sgerrand/alpine-pkg-glibc.
# There seems to be symbols (maybe functions) missing.
# It will work if you:
# $ apk --force-overwrite add libc6-compat gcompat

ENTRYPOINT [ "start.sh" ]
