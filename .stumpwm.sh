#!/bin/sh

# Some ideas taken from https://github.com/malk/dotfiles/blob/master/bin/stumpwm.sh

# dbus
eval `dbus-launch --sh-syntax --exit-with-session` &

# gnome-settings. Doesnt' make the control panel work though
gnome-settings-daemon &

# lets put the audio responsibility on a recent standard (apparently every
# solution is a different compromise of necessary evil?)
start-pulseaudio-x11 &

# since we are already on a gnome vibe, lets use gnome-keyring as our
# ssh-agent, as a bonus it will give to sensible applications access to ssh
# keys, password lists, etc
eval $(/usr/bin/gnome-keyring-daemon --daemonize --login --start --components=gpg,pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

# adds some sudo hocus pocus
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# Set keyboard settings and ensure will reapply if unplugged and replugged in
# https://unix.stackexchange.com/a/523959/28269
. /home/baggers/.stumpwm_on_input_change
inputplug -c /home/baggers/.stumpwm_on_input_change

#
xset s off
xset s noblank
xset dpms 0 0 0
xset -dpms

# kick it off
exec stumpwm
