#!/bin/bash
killall waybar
SDIR="/home/mustafa/.config/waybar"
waybar -c "$SDIR"/config2 -s "$SDIR"/style2.css &
swaymsg gaps outer all set 0 && swaymsg gaps inner all set 5

