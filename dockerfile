FROM alpine

RUN set -ex && \
    apk --update add privoxy && \
    apk add --no-cache --virtual .build-deps \
                                autoconf \
                                build-base \
                                libev-dev \
                                libtool \
                                linux-headers \
                                udns-dev \
                                libsodium-dev \
                                mbedtls-dev \
                                pcre-dev \
                                tar \
                                git \
                                automake \
                                c-ares \
                                c-ares-dev \
                                udns-dev && \
    cd /tmp && \
    git clone --depth=1 https://github.com/shadowsocks/simple-obfs.git . && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-documentation && make && \
    make install && \
    cd .. && \
    find /tmp -mindepth 1 -delete && \

    cd /tmp && \
    git clone --depth=1 https://github.com/shadowsocks/shadowsocks-libev.git . && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-documentation && make && \
    make install && \
    cd .. && \

    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    rm -rf /tmp/*

COPY privoxy.conf /etc/privoxy/config
