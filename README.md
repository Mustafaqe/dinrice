# Din Rice - Sway Desktop Environment

A beautiful, dynamic Sway window manager configuration integrating Pywal, Waybar, and Rofi with dynamic textures (CRT scanlines, glass blur) depending on your wallpaper selection in real-time!

> **Special Thanks:** I was heavily inspired by the [Ruixi-rebirth/sway-dotfiles](https://github.com/Ruixi-rebirth/sway-dotfiles.git) repository. Thank you for the inspiration!

##  Installation

To install this rice safely without destroying your current setup:

1. **Backup your existing configurations:**
   ```bash
   mv ~/.config/sway ~/.config/sway_bak
   mv ~/.config/waybar ~/.config/waybar_bak
   mv ~/.config/rofi ~/.config/rofi_bak
   ```

2. **Clone the repository and copy the configurations:**
   ```bash
   git clone https://github.com/Mustafaqe/dinrice.git /tmp/dinrice
   cp -r /tmp/dinrice/.config/* ~/.config/
   ```

3. **Reload Sway:**
   Press `Mod + Shift + c`. Waybar and Rofi will automatically boot up with the new configurations.

##  How to Add Your Own Wallpapers & Trigger Textures

Adding your own wallpaper is incredibly simple. This rice contains a custom dynamic engine built into `set_wallpaper.sh` that automatically themes Waybar and Rofi based on **keywords in your wallpaper filename**!

1. **Add your wallpapers:**
   Place any new `.png`, `.jpg`, or `.webp` inside the wallpaper directory:
   `~/.config/sway/wallpaper/`

2. **Trigger Dynamic Textures via Filename:**
   - **CRT Scanline Mode:** If you rename your wallpaper file to include the word `crt` anywhere in the filename (e.g., `synth_crt.png`), Waybar and Rofi will automatically drop opacity and apply a retro CSS CRT scanline effect!
   - **Glass / Blur Mode:** If you rename your wallpaper to include the words `glass` or `blur` (e.g., `mountains_blur.jpg`), the components will become highly translucent, mimicking a frosted glass blur.
   - **Default UI:** If neither word is found, menus will fall back to beautiful, opaque colors matched perfectly to the image using Pywal.
   
3. **Change the Wallpaper:**
   Press your bound shortcut (likely `Alt + Space` or through your Rofi menu) to open the Wallpaper selector and pick your new image. All system colors and menu textures will shift simultaneously!
