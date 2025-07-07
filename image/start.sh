#!/bin/sh
echo "Starting setup container please wait"
sleep 1

# Additional ip configuration
if [ -e /opt/xray/script/init.sh ]; then
  bash /opt/xray/script/init.sh
fi

cd /opt/xray/ || exit 1

echo "Start Xray core"
export XRAY_LOCATION_ASSET=/opt/xray/data
/opt/xray/xray run -confdir /opt/xray/config &
#pkill xray
echo "Start tun2socks or hev"
if [ "${USE_HEV}" = "true" ]; then
  /opt/xray/hev-socks5 /opt/xray/hev.yaml &
else
  /opt/xray/tun2socks -loglevel silent -tcp-sndbuf 512k -tcp-rcvbuf 512k -device tun0 -proxy socks5://127.0.0.1:10800 -interface eth0 &
fi
#pkill tun2socks
echo "Container customization is complete"
