#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:?UUID env var is required}"
cat > /tmp/config.json <<EOF
{
  "inbounds": [{
    "port": ${PORT},
    "listen": "0.0.0.0",
    "protocol": "vless",
    "settings": {"clients": [{"id": "${UUID}"}], "decryption": "none"},
    "streamSettings": {"network": "ws", "wsSettings": {"path": "/vless"}}
  }],
  "outbounds": [{"protocol": "freedom"}]
}
EOF
exec /usr/local/bin/xray run -c /tmp/config.json
