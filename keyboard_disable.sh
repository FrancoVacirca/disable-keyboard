#!/bin/bash
LAPTOP_KEYBOARD_ID="15"
EXTERNAL_KEYBOARD_ID="10"
INTERNAL_KEYBOARD_ENABLED=true

check_connect() {
    CONNECTED=$(xinput list-props "$EXTERNAL_KEYBOARD_ID" | grep "Device Enabled" | awk '{print $NF}')
    if [ "$CONNECTED" -eq 1 ]; then
        xinput disable "$LAPTOP_KEYBOARD_ID"
        INTERNAL_KEYBOARD_ENABLED=false
    else
        xinput enable "$LAPTOP_KEYBOARD_ID"
        INTERNAL_KEYBOARD_ENABLED=true
    fi
}

# Initial check and action
check_connect

while true; do
    sleep 2
    if ! xinput list | grep -q "$EXTERNAL_KEYBOARD_ID"; then
        if [ "$INTERNAL_KEYBOARD_ENABLED" = false ]; then
            xinput enable "$LAPTOP_KEYBOARD_ID"
            INTERNAL_KEYBOARD_ENABLED=true
        fi
    else
        if [ "$INTERNAL_KEYBOARD_ENABLED" = true ]; then
            xinput disable "$LAPTOP_KEYBOARD_ID"
            INTERNAL_KEYBOARD_ENABLED=false
        fi
    fi
done

