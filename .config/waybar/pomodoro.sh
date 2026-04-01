#!/usr/bin/env bash

STATE_FILE="/tmp/waybar-pomodoro"
WORK_TIME=1500 # 25 minutes
BREAK_TIME=300 # 5 minutes

# Icons
ICON_WORK=" "
ICON_BREAK=" "
ICON_PAUSED=" "
ICON_STOPPED=" "

function play_sound() {
    # System sound ID based on event
    canberra-gtk-play --id="$1" &>/dev/null &
}

function get_state() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo "stopped 0 0"
    fi
}

function save_state() {
    echo "$1 $2 $3" > "$STATE_FILE"
}

# status: current state (work, break, stopped, paused)
# end_time: unix timestamp when the current session ends
# remaining: remaining seconds when paused
read -r status end_time remaining <<< "$(get_state)"

case "$1" in
    "start")
        new_end=$(( $(date +%s) + WORK_TIME ))
        save_state "work" "$new_end" "$WORK_TIME"
        play_sound "message-new-instant"
        ;;
    "break")
        new_end=$(( $(date +%s) + BREAK_TIME ))
        save_state "break" "$new_end" "$BREAK_TIME"
        play_sound "bell"
        ;;
    "pause")
        if [ "$status" == "work" ] || [ "$status" == "break" ]; then
            rem=$(( end_time - $(date +%s) ))
            save_state "paused" "$end_time" "$rem"
        elif [ "$status" == "paused" ]; then
            new_end=$(( $(date +%s) + remaining ))
            # We need to know if it was work or break. Let's assume work for now or improve state.
            # For simplicity, if it was paused, we resume as work.
            save_state "work" "$new_end" "$remaining"
        fi
        ;;
    "stop"|"reset")
        save_state "stopped" 0 0
        ;;
    *)
        # Default: output JSON for Waybar
        now=$(date +%s)
        if [ "$status" == "work" ]; then
            rem=$(( end_time - now ))
            if [ $rem -le 0 ]; then
                notify-send "Pomodoro" "Work session finished! Take a break."
                play_sound "alarm-clock-elapsed"
                save_state "stopped" 0 0
                echo "{\"text\": \"$ICON_STOPPED Ready\", \"class\": \"stopped\"}"
            else
                printf "{\"text\": \"$ICON_WORK %02d:%02d\", \"class\": \"work\"}\n" $((rem / 60)) $((rem % 60))
            fi
        elif [ "$status" == "break" ]; then
            rem=$(( end_time - now ))
            if [ $rem -le 0 ]; then
                notify-send "Pomodoro" "Break finished! Back to work."
                play_sound "alarm-clock-elapsed"
                save_state "stopped" 0 0
                echo "{\"text\": \"$ICON_STOPPED Ready\", \"class\": \"stopped\"}"
            else
                printf "{\"text\": \"$ICON_BREAK %02d:%02d\", \"class\": \"break\"}\n" $((rem / 60)) $((rem % 60))
            fi
        elif [ "$status" == "paused" ]; then
            printf "{\"text\": \"$ICON_PAUSED %02d:%02d\", \"class\": \"paused\"}\n" $((remaining / 60)) $((remaining % 60))
        else
            echo "{\"text\": \"$ICON_STOPPED Pomo\", \"class\": \"stopped\"}"
        fi
        ;;
esac
