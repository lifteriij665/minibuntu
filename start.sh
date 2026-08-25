#!/bin/bash

set -e

echo "=========================================="
echo " Railway Mini Ubuntu + AimiliVPN"
echo "=========================================="

PORT="${PORT:-8080}"

echo "Railway PORT: ${PORT}"

# 第一次启动时生成 Aimili 配置
AUTH_FILE="/opt/aimilivpn/vpngate_data/ui_auth.json"

if [ ! -f "$AUTH_FILE" ]; then
    python3 - <<'PY'
import json
import secrets
import string
import os

chars = string.ascii_letters + string.digits

def password():
    while True:
        p = ''.join(secrets.choice(chars) for _ in range(16))
        if (
            any(c.islower() for c in p)
            and any(c.isupper() for c in p)
            and any(c.isdigit() for c in p)
        ):
            return p

cfg = {
    "host": "::",
    "port": 8787,
    "proxy_port": 7928,
    "secret_path": ''.join(secrets.choice(chars) for _ in range(16)),
    "username": ''.join(secrets.choice(chars) for _ in range(12)),
    "password": password(),
}

os.makedirs("/opt/aimilivpn/vpngate_data", exist_ok=True)

with open("/opt/aimilivpn/vpngate_data/ui_auth.json", "w") as f:
    json.dump(cfg, f, indent=2)

print("AimiliVPN 初始配置已生成")
print("管理地址路径:", cfg["secret_path"])
print("管理账号:", cfg["username"])
print("管理密码:", cfg["password"])
PY
fi

# 把 Railway 的 PORT 注入 nginx
sed -i "s/__RAILWAY_PORT__/${PORT}/g" /etc/nginx/nginx.conf

# 启动 supervisor
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf