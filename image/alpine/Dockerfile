ARG ALPINE_VERSION=3.22
FROM alpine:${ALPINE_VERSION} as builder

RUN apk add --no-cache \
    bash \
    unzip && \
    mkdir -p /build

COPY ./tmp/* /build/

RUN cd /build && \
    unzip -o tun2socks-linux-armv7.zip && \
    unzip -o Xray-linux-arm32-v7a.zip && \
    chmod +x tun2socks-linux-armv7 xray

FROM alpine:${ALPINE_VERSION}

COPY start.sh /opt/xray/

RUN apk add --no-cache \
    bash \
    openrc \
    openresolv \
    iproute2 \
    curl \
    tcpdump \
    iptables-legacy \
    libqrencode && \
    mkdir -p /opt/xray && \
    mkdir -p /opt/xray/config && \
    mkdir -p /opt/xray/data && \
    mkdir -p /opt/xray/script && \
    chmod +x /opt/xray/start.sh && \
    ln -sf /usr/sbin/iptables-legacy /usr/sbin/iptables && \
    ln -sf /usr/sbin/ip6tables-legacy /usr/sbin/ip6tables

COPY --from=builder /build/tun2socks-linux-armv7 /opt/xray/tun2socks
COPY --from=builder /build/xray /opt/xray/

COPY ./data/* /opt/xray/data/
COPY ./start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
RUN sed -i 's/\r//' /opt/start.sh

RUN sed -i 's/^tty/#tty/' /etc/inittab
ENTRYPOINT ["sh", "-c"]
CMD ["/bin/bash /opt/start.sh && /sbin/init"]
