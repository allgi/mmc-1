#!/bin/sh

# Checking if x11vnc is installed
apt-get -y install x11vnc

# Copying autostartup entry to all users
for user in /home/*; do
    mkdir -p $user/.config/autostart/
    cp x11vnc.desktop $user/.config/autostart/
done
