#!/usr/bin/env bash

# Directory where wallpapers are stored
WALLPAPER_DIR="/home/mustafa/.config/sway/wallpaper"
ROFI_THEME="$HOME/.config/rofi/wallpaper_theme.rasi"

# Find all supported image files (exclude directory names)
wallpapers=$(find -L "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \))

# Create the menu content for rofi with thumbnails using a pipeable stream
# format: display text\x00icon\x1f/path/to/image.png
# Use printf to handle null bytes safely
get_menu_content() {
    # Special "Randomize Choice" icon
    printf "Randomize Choice\0icon\x1fcomputer-desktop\n"
    
    while IFS= read -r path; do
        filename=$(basename "$path")
        # Format the entry with a null byte for metadata
        # DisplayFilename\0icon\x1fPathToImage\n
        printf "%s\0icon\x1f%s\n" "$filename" "$path"
    done <<< "$wallpapers"
}

# Use rofi with dmenu and icon support
# Note: we use -no-config if needed, but the theme should be enough
selected_name=$(get_menu_content | rofi -dmenu -i -show-icons -p "Select Wallpaper" -theme "$ROFI_THEME")

# Exit if no selection was made
if [ -z "$selected_name" ]; then
    exit 0
fi

if [ "$selected_name" == "Randomize Choice" ]; then
    # Pick a random wallpaper
    if [ -f "$HOME/.config/sway/set_wallpaper.sh" ]; then
        "$HOME/.config/sway/set_wallpaper.sh" "random"
    fi
else
    # Find the full path of the selected wallpaper by matching the filename exactly
    # We must match against the list of full paths
    selected_path=$(echo "$wallpapers" | while read -r p; do if [[ $(basename "$p") == "$selected_name" ]]; then echo "$p"; break; fi; done)
    
    # Apply the selection
    if [ -n "$selected_path" ] && [ -f "$HOME/.config/sway/set_wallpaper.sh" ]; then
        "$HOME/.config/sway/set_wallpaper.sh" "$selected_path"
    fi
fi
