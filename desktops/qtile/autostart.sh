#!/bin/sh

# KDE Polkit agent
/usr/libexec/polkit-kde-authentication-agent-1 &

# Networking
nm-applet &

# Clipboard
copyq &

# Screenshot tool
flameshot &

# Optional apps
 steam -silent &
 discord --start-minimized &
# picom & # Animations
# blueman-applet & # Bluetooth Manager

