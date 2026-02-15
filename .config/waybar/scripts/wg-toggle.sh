#!/usr/bin/env bash

CONN="wg0"

if nmcli -t -f NAME,STATE connection show --active | grep -q "^${CONN}:activated$"; then
    nmcli connection down "$CONN"
else
    nmcli connection up "$CONN"
fi

