#!/bin/bash

# Din Rice - Sway Desktop Environment Installer
# Designed for Arch Linux

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[m'

echo -e "${BLUE}Starting Din Rice Installation...${NC}"

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}This script is designed for Arch Linux only. Exiting.${NC}"
    exit 1
fi

# Function to check and install AUR helper (yay)
install_yay() {
    if ! command -v yay &> /dev/null; then
        echo -e "${BLUE}Installing yay (AUR helper)...${NC}"
        sudo pacman -S --needed base-devel git
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
    fi
}

# Core & Utility Dependencies
REPO_DEPS=(
    "sway" "swaybg" "waybar" "kitty" "python-pywal" "mako" 
    "network-manager-applet" "fcitx5-im" "grim" "slurp" 
    "wl-clipboard" "imagemagick" "light" "playerctl" 
    "libpulse" "swayidle" "mpd" "ncmpcpp" "mpc" "cava" 
    "ttf-jetbrains-mono-nerd" "polkit-gnome" "jq"
)

# AUR Dependencies
AUR_DEPS=(
    "rofi-wayland" "swaylock-effects-git" "catppuccin-gtk-theme-mocha" 
    "papirus-icon-theme" "catppuccin-cursors-mocha" "otf-hacker-nerd"
    "telegram-desktop" "firefox" "netease-cloud-music" 
    "youtube-music-bin" "icalingua-plus-plus"
)

echo -e "${BLUE}Syncing system clock...${NC}"
sudo timedatectl set-ntp true

echo -e "${BLUE}Installing repository dependencies...${NC}"
sudo pacman -S --needed --noconfirm "${REPO_DEPS[@]}"

echo -e "${BLUE}Setting up AUR support...${NC}"
install_yay

echo -e "${BLUE}Installing AUR dependencies...${NC}"
yay -S --needed --noconfirm "${AUR_DEPS[@]}"

# Backup existing configs
echo -e "${BLUE}Backing up existing configurations...${NC}"
BACKUP_DIR="$HOME/.config/sway_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

for dir in sway waybar rofi kitty; do
    if [ -d "$HOME/.config/$dir" ]; then
        mv "$HOME/.config/$dir" "$BACKUP_DIR/"
        echo "Backed up $dir to $BACKUP_DIR"
    fi
done

# Copy new configs
echo -e "${BLUE}Applying new configurations...${NC}"
mkdir -p "$HOME/.config" "$HOME/.local/share/applications"
cp -rv .config/* "$HOME/.config/"
if [ -d ".local" ]; then
    cp -rv .local/* "$HOME/.local/"
fi

# Replace template home path with actual home path
echo -e "${BLUE}Customizing paths for your user...${NC}"
find "$HOME/.config/sway" "$HOME/.config/waybar" "$HOME/.local/share/applications" -type f -exec sed -i "s|/home/mustafa|$HOME|g" {} +

# Ensure scripts are executable
chmod +x "$HOME/.config/sway/"*.sh
chmod +x "$HOME/.config/waybar/"*.sh
chmod +x "$HOME/.config/rofi/"*.sh 2>/dev/null || true

# Set up wallpapers directory if missing
mkdir -p "$HOME/.config/sway/wallpaper"
if [ -d "Background" ]; then
    cp -r Background/* "$HOME/.config/sway/wallpaper/" 2>/dev/null || true
fi

echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${BLUE}Next Steps:${NC}"
echo -e "1. Log out and log into Sway."
echo -e "2. Use ${BLUE}Alt + Space${NC} to open the wallpaper selector."
echo -e "3. Use ${BLUE}Super${NC} (Windows Key) for the launcher."
echo -e "4. Check ${BLUE}README.md${NC} for more shortcuts."

echo -e "${GREEN}Enjoy your new Din Rice!${NC}"
