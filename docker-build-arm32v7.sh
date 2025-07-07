#!/bin/zsh

export XRAY_VERSION="v25.6.8"
export T2S_VERSION="v2.6.0"
export HEV_VERSION="2.11.0"
XRAY_FILE="Xray-linux-arm32-v7a.zip"
T2S_FILE="tun2socks-linux-armv7.zip"
HEV_FILE="hev-socks5-tunnel-linux-arm32v7"


TMP_DIR="./image/tmp"
DIST_DIR="./image/dist"
DATA_DIR="./image/data"
mkdir -p "${TMP_DIR}"
mkdir -p "${DIST_DIR}"
mkdir -p "${DATA_DIR}"


BIN_XRAY_FILE="${TMP_DIR}/${XRAY_FILE}"
BIN_T2S_FILE="${TMP_DIR}/${T2S_FILE}"
BIN_HEV_FILE="${TMP_DIR}/${HEV_FILE}"
#arm32v7
#XRay v25.6.8
#https://github.com/XTLS/Xray-core/releases/download/v25.6.8/Xray-linux-arm32-v7a.zip

XRAY_URL="https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/${XRAY_FILE}"
if [ ! -e "${BIN_XRAY_FILE}" ]; then
  wget -P "${TMP_DIR}" "${XRAY_URL}"
fi

#arm32v7
#tun2socks
#https://github.com/xjasonlyu/tun2socks/releases/download/v2.6.0/tun2socks-linux-armv7.zip
T2S_URL="https://github.com/xjasonlyu/tun2socks/releases/download/${T2S_VERSION}/${T2S_FILE}"
if [ ! -e "${BIN_T2S_FILE}" ]; then
  wget -P "${TMP_DIR}" "${T2S_URL}"
fi

#https://github.com/heiher/hev-socks5-tunnel/releases/download/2.11.0/hev-socks5-tunnel-linux-arm32v7
HEV_URL="https://github.com/heiher/hev-socks5-tunnel/releases/download/${HEV_VERSION}/${HEV_FILE}"
if [ ! -e "${BIN_HEV_FILE}" ]; then
  wget -P "${TMP_DIR}" "${HEV_URL}"
fi

# default geosite geoip
rm -f ${DATA_DIR}/*.dat*
wget -P ${DATA_DIR} "https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geoip.dat"
wget -P ${DATA_DIR} "https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geosite.dat"

cd image || exit
docker image rm mikrotik-vless:latest
docker build --no-cache --progress=plain --platform linux/arm/v7 --output=type=docker --tag mikrotik-vless:latest .

cd ..

rm -rf ${DIST_DIR}/xray_image.tar
docker save mikrotik-vless:latest -o "${DIST_DIR}/xray_image.tar"
