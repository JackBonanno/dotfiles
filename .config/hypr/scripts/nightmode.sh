#!/bin/bash

CURRENT_TEMP=$(busctl --user get-property rs.wl-gammarelay / rs.wl.gammarelay Temperature | awk '{print $2}')

if [ "$CURRENT_TEMP" -ge 6500 ]; then
    busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 3500
else
    busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 6500
fi
