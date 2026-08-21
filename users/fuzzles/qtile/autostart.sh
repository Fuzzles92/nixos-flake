#!/bin/sh

# Polkit
lxqt-policykit-agent &

# Networking
nm-applet &

# Clipboard
copyq &

# Screenshot tool
flameshot &

# Other Applications
steam -silent &
discord --start-minimized &
