#!/bin/sh
# A script to set a random wallpaper and update the system theme
# If a path is provided as the first argument, use it; otherwise pick a random one.

WALLPAPER_DIR="/home/mustafa/.config/sway/wallpaper"

# File to save the current wallpaper
SAVED_WALLPAPER="$WALLPAPER_DIR/current_wallpaper"

pick_random() {
    find -L "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n1
}

if [ -z "$1" ]; then
    # If no argument, try to read the saved one; if it doesn't exist, pick random.
    if [ -f "$SAVED_WALLPAPER" ]; then
        WALLPAPER=$(cat "$SAVED_WALLPAPER")
        # Validate that the file still exists and is a file
        if [ ! -f "$WALLPAPER" ]; then
             WALLPAPER=$(pick_random)
             # Save the new random selection
             echo "$WALLPAPER" > "$SAVED_WALLPAPER"
        fi
    else
        WALLPAPER=$(pick_random)
        # Save the initial random selection
        echo "$WALLPAPER" > "$SAVED_WALLPAPER"
    fi
elif [ "$1" == "random" ]; then
    # Explicitly pick a new random wallpaper and save it
    WALLPAPER=$(pick_random)
    echo "$WALLPAPER" > "$SAVED_WALLPAPER"
else
    # A specific path was provided, use it and save it
    WALLPAPER="$1"
    echo "$WALLPAPER" > "$SAVED_WALLPAPER"
fi

# Exit if no wallpaper found
[ -z "$WALLPAPER" ] && exit 1

# Don't run multiple wal processes at once
if pgrep -x wal > /dev/null; then
    echo "wal is already running, skipping updated"
    exit 0
fi

# Update theme with pywal (colors only)
wal -i "$WALLPAPER" -q -n
pywalfox update

# Stop any previous swaybg processes
# Using pkill -x is faster and cleaner!
pkill -x swaybg 2>/dev/null

# Set the wallpaper using swaybg
swaybg -i "$WALLPAPER" -m fill &

# Only restart Waybar if it is NOT already running or if we specifically want to force it
# If your Waybar CSS imports the colors using @import, it should auto-reload without a restart.
if ! pgrep -x waybar > /dev/null; then
    ~/.config/waybar/launch_waybar.sh &
fi
