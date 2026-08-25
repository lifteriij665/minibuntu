#!/bin/bash

set -e

echo "================================="
echo " Railway Mini Ubuntu"
echo "================================="

echo "PORT=${PORT:-8080}"

echo -n "Outbound IPv4: "
curl -4 -s https://ifconfig.me || true
echo

python3 -m http.server "${PORT:-8080}" --bind 0.0.0.0