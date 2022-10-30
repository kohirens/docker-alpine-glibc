FROM alpine:3.16 AS base

ARG GLIBC_VER='2.35-r0'

ENV LD_LIBRARY_PATH='/usr/lib:/lib'
ENV LD_LIBRARY_PATH='/lib:/usr/lib:/usr/glibc-compat/lib:/usr/local/lib'
ENV LD_LIBRARY_PATH='${LD_LIBRARY_PATH}:/usr/include/sys'

RUN apk --no-progress --purge --no-cache upgrade \
&& apk --no-progress --purge --no-cache add --upgrade --virtual=build_deps \
   ca-certificates \
   libstdc++ \
   gnupg \
&& apk --no-progress --purge --no-cache upgrade \
&& rm -vrf /var/cache/apk/*

# Install vanilla GLibC: https://github.com/sgerrand/alpine-pkg-glibc
WORKDIR "/tmp"

RUN cat /etc/nsswitch.conf \
 && echo && echo \
 && cat /etc/profile.d/locale.sh \
 && echo && echo

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk
RUN apk add --force-overwrite glibc-${GLIBC_VER}.apk glibc-bin-${GLIBC_VER}.apk glibc-i18n-${GLIBC_VER}.apk
RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
RUN /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "C.UTF-8"
RUN rm -rf /tmp/*

RUN cat /etc/nsswitch.conf \
 && echo && echo \
 && cat /etc/profile.d/locale.sh \
 && echo && echo \

ENTRYPOINT [ ]
CMD [ ]
