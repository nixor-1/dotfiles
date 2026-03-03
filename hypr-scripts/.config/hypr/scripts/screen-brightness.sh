#!/bin/bash

# You can call this script like this:
# $./brightness.sh up
# $./brightness.sh down
# $./brightness.sh set 50%

BRIGHTNESS_STEP=5% # Brightness step (percentage)
NOTIFICATION_ID=2594 # A unique ID to replace brightness notifications
NOTIFICATION_TIMEOUT=1000 # Timeout in milliseconds

# Gets the absolute value of the screen's brightness in percentages.
function get_brightness {
    brightnessctl -m | cut -d',' -f4 | tr -d '%'
}

function get_brightness_step {
    local current=$1
    local direction=$2   # "up" or "down"

    if [ "$direction" = "up" ]; then
        if [ "$current" -lt 5 ]; then
            echo 1
        else
            echo 5
        fi
    else # down
        if [ "$current" -le 5 ]; then
            echo 1
        else
            echo 5
        fi
    fi
}

function send_brightness_notification {
    local brightness=$(get_brightness)
    
    # Check if brightnessctl returned a valid number
    if ! [[ "$brightness" =~ ^[0-9]+$ ]]; then
        dunstify -i dialog-warning -t 3000 -u critical "Brightness Error" "Could not get brightness level."
        return
    fi

    local icon_name
    if [ "$brightness" -eq 0 ]; then
        icon_name="display-brightness-off"
    elif [ "$brightness" -lt 33 ]; then
        icon_name="display-brightness-low"
    elif [ "$brightness" -lt 66 ]; then
        icon_name="display-brightness-medium"
    else
        icon_name="display-brightness-high"
    fi

    # Send the notification, using NOTIFICATION_ID to replace previous ones
    dunstify -i "$icon_name" -t $NOTIFICATION_TIMEOUT -r $NOTIFICATION_ID "Brightness $brightness%" -h int:value:"$brightness"
}

case $1 in
    up)
        current_brightness=$(get_brightness)
        brightness_step=$(get_brightness_step "$current_brightness" "up")
        brightnessctl set "${brightness_step}%+"
        send_brightness_notification
        ;;
    down)
        current_brightness=$(get_brightness)
        brightness_step=$(get_brightness_step "$current_brightness" "down")
        brightnessctl set "${brightness_step}%-"
        send_brightness_notification
        ;;
    set)
        # Optional: Allows setting an exact value (e.g., $./brightness.sh set 75%)
        if [ -z "$2" ]; then
            echo "Error: Must provide a value (e.g., 50%) for 'set'."
            exit 1
        fi
        brightnessctl set "$2"
        send_brightness_notification
        ;;
    get)
        # Optional: Just prints the current percentage
        get_brightness
        ;;
    *)
        echo "Usage: $0 {up|down|set <PERCENTAGE>|get}"
        exit 1
        ;;
esac
