# Configure X
xsetroot -cursor_name left_ptr
xrdb -merge ~/.Xdefaults
setxkbmap -option "ctrl:nocaps"

# Set background
~/.fehbg

# Start a window compositor. This ensures Google Chrome paints correctly.
xcompmgr -n &

# Start the system tray
stalonetray &

# Numlock
numlockx

# Start screensaver
xscreensaver -no-splash &

# Start sound server
dbus-launch pulseaudio --start

# Pasystray
pasystray &

# Fcitx
fcitx
