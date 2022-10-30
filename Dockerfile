FROM alpine:3.16

ARG GLIBC_VER='2.35-r0'

ENV LD_LIBRARY_PATH='/usr/lib:/lib'
ENV LD_LIBRARY_PATH='/lib:/usr/lib:/usr/glibc-compat/lib:/usr/local/lib'
ENV LD_LIBRARY_PATH='${LD_LIBRARY_PATH}:/usr/include/sys'

ENV LANG='C.UTF-8'

RUN apk --no-progress --purge --no-cache upgrade \
&& apk --no-progress --purge --no-cache add --upgrade --virtual=build_deps \
   ca-certificates \
   curl \
   libstdc++ \
   gnupg \
&& apk --no-progress --purge --no-cache upgrade \
&& rm -vrf /var/cache/apk/*

# Install vanilla GLibC: https://github.com/sgerrand/alpine-pkg-glibc
#
# NOTE: when you run any app that uses the glibc you will get a info message 
# output. You can ignore these for now, they are caused by a dependency that is
# in pre-relase mode. I do not believe this is caused by the GLibC files 
# themselves, but an external dependency from the Alpine repos that is in 
# pre-release mode.
#
# I dug into this and found the cause, but forgot to record them in my notes.
# I Will need to dig into this again to verify the exact dependency that causes
# this.

RUN cd /tmp \
 && curl -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && curl -LO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
 && curl -LO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
 && curl -LO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk \
 && apk add glibc-${GLIBC_VER}.apk \
    glibc-bin-${GLIBC_VER}.apk \
    glibc-i18n-${GLIBC_VER}.apk \
 && echo "export LANG=${LANG}" > /etc/profile.d/locale.sh \
 && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "${LANG}" || true \
 && rm /etc/apk/keys/sgerrand.rsa.pub \
    glibc-${GLIBC_VER}.apk \
    glibc-bin-${GLIBC_VER}.apk \
    glibc-i18n-${GLIBC_VER}.apk

#RUN apk --no-progress --purge --no-cache upgrade \
# && apk --no-progress --purge --no-cache add --upgrade --virtual=build_deps \
#    binutils \
# && apk --no-progress --purge --no-cache upgrade \
# && rm -vrf /var/cache/apk/*

#RUN objdump -p /usr/lib/libstdc\+\+.so.6

ENTRYPOINT [ ]
CMD [ ]
