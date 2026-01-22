#!/usr/bin/env bash

CONN="wg0"

if ! nmcli connection show "$CONN" > /dev/null 2>&1; then
    exit 0
fi

if nmcli -t -f DEVICE,STATE connection show --active | grep -q "^wg0:activated$"; then
    echo "WG ↑"
else
    echo "WG ↓"
fi

