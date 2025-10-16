#!/bin/bash

# Arguments
APP_CMD="$1"       # command to launch (e.g., spotify)
WORKSPACE="$2"     # workspace number (e.g., 9)
APP_CLASS="$3"     # window class to look for (e.g., spotify)

# Ensure all arguments are present
if [[ -z "$APP_CMD" || -z "$WORKSPACE" || -z "$APP_CLASS" ]]; then
    echo "Usage: $0 <command> <workspace> <window_class>"
    exit 1
fi

# Check if the window is already open (match by class name)
if hyprctl clients | grep -qi "class: $APP_CLASS"; then
    # Focus the workspace where it's already running
    hyprctl dispatch workspace "$WORKSPACE"
else
    # Move to workspace and launch app
    hyprctl dispatch workspace "$WORKSPACE"
    "$APP_CMD" &
fi

