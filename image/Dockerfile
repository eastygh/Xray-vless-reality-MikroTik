ARG ALPINE_VERSION=latest

FROM alpine:${ALPINE_VERSION} AS builder

RUN apk add --no-cache \
    bash \
    unzip

WORKDIR /build

COPY ./tmp/*.zip ./

RUN unzip -o tun2socks-linux-armv7.zip && \
    unzip -o Xray-linux-arm32-v7a.zip && \
    chmod +x tun2socks-linux-armv7 xray && \
    rm -f *.zip

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="eastygh@github.com" \
      description="Xray with tun2socks and HEV socks5 tunnel" \
      version="1.0"

RUN apk add --no-cache \
    bash \
    openrc \
    tzdata \
    openssl \
    openresolv \
    curl \
    tcpdump \
    ca-certificates && \
    mkdir -p /opt/xray/{config,data,script} && \
    ln -sf /usr/sbin/iptables-legacy /usr/sbin/iptables && \
    ln -sf /usr/sbin/ip6tables-legacy /usr/sbin/ip6tables && \
    rm -rf /var/cache/apk/* /tmp/*

COPY --from=builder /build/tun2socks-linux-armv7 /opt/xray/tun2socks
COPY --from=builder /build/xray /opt/xray/xray
COPY ./tmp/hev-socks5-tunnel-linux-arm32v7 /opt/xray/hev-socks5

COPY ./hev.yaml /opt/xray/
COPY ./data/* /opt/xray/data/
COPY ./start.sh /opt/xray/
COPY ./start.sh /opt/

RUN chmod +x \
    /opt/start.sh \
    /opt/xray/start.sh \
    /opt/xray/tun2socks \
    /opt/xray/xray \
    /opt/xray/hev-socks5 && \
    sed -i 's/\r//' /opt/start.sh /opt/xray/start.sh && \
    sed -i 's/^tty/#tty/' /etc/inittab && \
    adduser -D -u 1000 xrayuser && \
    chown -R xrayuser:xrayuser /opt/xray

#USER xrayuser
WORKDIR /opt/xray

ENV USE_HEV="false" \
    XRAY_CONFIG="/opt/xray/config" \
    XRAY_DATA="/opt/xray/data" \
    XRAY_LOCATION_ASSET=/opt/xray/data \
    TZ=Europe/Moscow

#HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
#    CMD curl -f http://localhost:8080/ || exit 1

ENTRYPOINT ["sh", "-c"]
CMD ["/bin/sh", "-c", "/opt/start.sh & exec /sbin/init"]
