#!/bin/bash
# Run the same gamedig the LinuxGSM monitor uses, from inside the image.
# The host test uses the runner's gamedig, which can still query protocol-valve.
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
    [ -n "$val" ] && querytype=$val
    val=$(read_setting "$f" port || true)
    [ -n "$val" ] && port=$val
done

if [ -z "$querytype" ] || [ -z "$port" ]; then
    echo "missing querytype (${querytype:-empty}) or port (${port:-empty})"
    exit 1
fi

echo "gamedig --type ${querytype} 127.0.0.1:${port}"
raw=$(gamedig --type "$querytype" "127.0.0.1:${port}")
echo "$raw"
name=$(printf '%s\n' "$raw" | jq -r '.name // empty')
if [ "$name" != "LinuxGSM" ]; then
    echo "monitor query failed (name=${name:-empty})"
    exit 1
fi
