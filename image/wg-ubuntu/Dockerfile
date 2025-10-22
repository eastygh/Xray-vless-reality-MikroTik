FROM arm32v7/ubuntu:20.04 AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    unzip && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /build

COPY ./tmp/* /build/

RUN cd /build && \
    unzip -o Xray-linux-arm32-v7a.zip

FROM arm32v7/ubuntu:20.04

LABEL maintainer="eastygh@github.com" \
      description="Xray for WG connect with mikrotik" \
      version="1.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    tcpdump \
    wireguard-tools \
    procps \
    curl \
    wget \
    systemd \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates \
    mkdir -p /opt/xray && \
    mkdir -p /opt/xray/config && \
    mkdir -p /opt/xray/data && \
    mkdir -p /opt/xray/script

COPY --from=builder /build/xray /opt/xray/
COPY wg-debian/start.sh /opt/

RUN chmod +x /opt/start.sh && \
   sed -i 's/\r//' /opt/start.sh

ENV USE_HEV="false" \
    XRAY_CONFIG="/opt/xray/config" \
    XRAY_DATA="/opt/xray/data" \
    XRAY_LOCATION_ASSET=/opt/xray/data

WORKDIR /opt/xray

ENTRYPOINT ["sh", "-c"]
CMD ["/bin/bash /opt/start.sh && tail -f /dev/null"]