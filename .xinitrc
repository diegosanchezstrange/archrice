#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

userresources=$HOME/.Xresources

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

exec i3
