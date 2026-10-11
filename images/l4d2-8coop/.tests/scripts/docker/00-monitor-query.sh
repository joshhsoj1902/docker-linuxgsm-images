#!/bin/bash
# Query with this image's gamedig and the querytype LinuxGSM actually loaded.
# gamedig 5.3 can miss 127.0.0.1 while the host IP answers, so try every local address.
set -eu

cfgdir=/data/config-lgsm/l4d2server
querytype=""
port=""

read_setting() {
    local file=$1 key=$2 line
    [ -f "$file" ] || return 0
    line=$(grep -E "^${key}=" "$file" | tail -1 || true)
    [ -n "$line" ] || return 0
    printf '%s' "${line#*=}" | tr -d '"'
}

for f in "$cfgdir/_default.cfg" "$cfgdir/common.cfg" "$cfgdir/l4d2server.cfg"; do
    val=$(read_setting "$f" querytype || true)
    if [ -n "$val" ]; then
        querytype=$val
    fi
    val=$(read_setting "$f" port || true)
    if [ -n "$val" ]; then
        port=$val
    fi
done

if [ -z "$querytype" ] || [ -z "$port" ]; then
    echo "missing querytype (${querytype:-empty}) or port (${port:-empty})"
    exit 1
fi

echo "effective querytype=${querytype} port=${port}"

ips="$(hostname -I 2>/dev/null || true) 127.0.0.1"
for ip in $ips; do
    echo "gamedig --type ${querytype} ${ip}:${port}"
    raw=$(gamedig --type "$querytype" "${ip}:${port}" || true)
    echo "$raw"
    name=$(printf '%s\n' "$raw" | jq -r '.name // empty' || true)
    if [ "$name" = "LinuxGSM" ]; then
        exit 0
    fi
done

echo "monitor query failed for querytype=${querytype}"
exit 1
