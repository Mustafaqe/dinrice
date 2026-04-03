#!/bin/sh
FILE=$(date "+%Y-%m-%d"T"%H:%M:%S").png
# Get the picture from maim
sh -c 'slurp | grim -g - ~/Pictures/src.png && notify-send "Screenshot" "Area screenshot taken"'
# add shadow, round corner, border and watermark
convert /home/mustafa/Pictures/src.png \
	\( +clone -alpha extract \
	-draw 'fill black polygon 0,0 0,8 8,0 fill white circle 8,8 8,0' \
	\( +clone -flip \) -compose Multiply -composite \
	\( +clone -flop \) -compose Multiply -composite \
	\) -alpha off -compose CopyOpacity -composite /home/mustafa/Pictures/output.png
#
convert /home/mustafa/Pictures/output.png -bordercolor none -border 20 \( +clone -background black -shadow 80x8+15+15 \) \
	+swap -background transparent -layers merge +repage /home/mustafa/Pictures/$FILE
#
composite -gravity Southeast ~/.config/sway/watermark.png /home/mustafa/Pictures/$FILE /home/mustafa/Pictures/$FILE
#
# # Send the Picture to clipboard
wl-copy < /home/mustafa/Pictures/$FILE
#
# # remove the other pictures
rm /home/mustafa/Pictures/src.png /home/mustafa/Pictures/output.png
