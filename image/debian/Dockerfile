ARG UBUNTU_VERSION=jammy-20240205
FROM arm32v7/debian:bullseye-slim as builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    unzip && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /build

COPY ./tmp/* /build/

RUN cd /build && \
    unzip -o tun2socks-linux-armv7.zip && \
    unzip -o Xray-linux-arm32-v7a.zip && \
    chmod +x tun2socks-linux-armv7 xray

FROM arm32v7/debian:bullseye-slim

COPY ../start.sh /opt/xray/

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    systemd-sysv \
    openresolv \
    iproute2 \
    curl \
    tcpdump \
    iptables \
    procps \
    iputils-ping \
    qrencode && \
    update-alternatives --set iptables /usr/sbin/iptables-legacy && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/xray && \
    mkdir -p /opt/xray/config && \
    mkdir -p /opt/xray/data && \
    mkdir -p /opt/xray/script && \
    chmod +x /opt/xray/start.sh

COPY --from=builder /build/tun2socks-linux-armv7 /opt/xray/tun2socks
COPY --from=builder /build/xray /opt/xray/

COPY ./data/* /opt/xray/data/
COPY ../start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
RUN sed -i 's/\r//' /opt/start.sh

ENTRYPOINT ["sh", "-c"]
CMD ["/bin/bash /opt/start.sh && /sbin/init"]