#!/bin/sh

# Ensure only one instance of this script is running
# We use pkill -o to kill the oldest instance if one exists, 
# but pgrep -x to check is safer for start-up
if pgrep -x "dynamic_wallpaper.sh" | grep -v $$ > /dev/null; then
    pkill -x "dynamic_wallpaper.sh"
    sleep 1
fi

# A loop to rotate the wallpaper every 10 minutes
while true; do
    # Run the wallpaper setter
    if [ -f "/home/mustafa/.config/sway/set_wallpaper.sh" ]; then
        "/home/mustafa/.config/sway/set_wallpaper.sh"
    fi
    
    # Wait for 10 minutes before next change
    sleep 600
done

