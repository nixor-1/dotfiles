#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

VOLUME_STEP=5%
NOTIFICATION_ID=2695 # A unique ID to replace volume notifications.
NOTIFICATION_TIMEOUT=1000 # Timeout in milliseconds.

function get_volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -n 1 | tr -d '%'
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=$(get_volume)
    
    if [ "$volume" -eq 0 ]; then
        icon_name="audio-volume-muted"
        title="Mute"
        bar="" # No bar when muted/zero
    elif [ "$volume" -lt 33 ]; then
        icon_name="audio-volume-low"
        title=""
    elif [ "$volume" -lt 66 ]; then
        icon_name="audio-volume-medium"
        title=""
    else
        icon_name="audio-volume-high"
        title=""
    fi

    # Send the notification.
    dunstify -i "$icon_name" -t $NOTIFICATION_TIMEOUT -r $NOTIFICATION_ID "Volume $volume%" -h int:value:"$volume"
}

case $1 in
    up)
	    pactl set-sink-mute @DEFAULT_SINK@ false # Unmute
	    pactl set-sink-volume @DEFAULT_SINK@ +5%
	    send_notification
	    ;;
    down)
	    pactl set-sink-mute @DEFAULT_SINK@ false # Unmute
	    pactl set-sink-volume @DEFAULT_SINK@ -5%
	    send_notification
	    ;;
    mute)
    	pactl set-sink-mute @DEFAULT_SINK@ toggle

	    if is_mute ; then
	        dunstify -i audio-volume-muted -t 8 -r 2593 -u normal "Mute"
	    else
	        send_notification
	    fi
	    ;;
    get)
        get_volume
        ;;
esac
