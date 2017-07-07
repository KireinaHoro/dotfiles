#!/bin/sh

# Configure PATH so that we can access our scripts below
PATH=$PATH:~/.cabal/bin:~/.xmonad/bin

# Configure X
xsetroot -cursor_name left_ptr &
xrdb -merge ~/.Xdefaults &
setxkbmap -option "ctrl:nocaps" &

# Start a window compositor. This ensures Google Chrome paints correctly.
xcompmgr -n &

# Start the system tray
stalonetray &

# Numlock
numlockx

# Start screensaver
xscreensaver -no-splash &

# Start sound server
pulseaudio --start --log-target=syslog &

# Pasystray
pasystray &

# Fcitx
fcitx &

if [ -x /usr/bin/nm-applet ] ; then
   nm-applet --sm-disable &
fi
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
