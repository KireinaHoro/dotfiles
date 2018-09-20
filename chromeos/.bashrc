# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi


# Put your fun stuff here.

# Mount ~ and /tmp with #execution perms, / rw
if egrep "/(home/chronos/user|tmp) .*noexec" /proc/mounts &>/dev/null; then
    sudo mount -o remount,exec /home/chronos/user
    sudo mount -o remount,exec /tmp
    sudo mount -o remount,rw /
fi

# Check and place chronos in group usb for Yubikey perms
if ! groups | grep usb &>/dev/null && \
    [ -z ${_IGNORE_USER_GROUP+x} ] && [ -z ${_GROUP_CHANGE_DONE+x} ]; then
    echo "User chronos is not in group usb."
    echo "This will prevent gpg from accessing GPG cards."
    while true; do
        read -p 'Add chronos to group usb? [Y/n]' Answer
        case $Answer in
            '' | [Yy]* )
                if grep "/dev/root / ext2 ro" /proc/mounts &>/dev/null; then
                    echo "Mounting / as read-write..."
                    # from make_dev_ssd.sh
                    target_partition=$(($(echo $(rootdev -s 2>/dev/null) | sed -n 's/.*\([0-9][0-9]*\)$/\1/p')-1))
                    sudo /usr/share/vboot/bin/make_dev_ssd.sh --remove_rootfs_verification \
                        --partitions $target_partition

                    echo "Rebooting..."
                    sleep 1 && sudo reboot
                    exit 0
                fi
                sudo usermod -a -G usb chronos
                echo "Group change will take effect on next login."
                export _GROUP_CHANGE_DONE=mark
                break;
                ;;
            [Nn]* )
                echo "You will be prompted on next shell start."
                export _IGNORE_USER_GROUP=mark
                break;
                ;;
            * )
                echo Answer $Answer not understood.
        esac
    done;
fi

# Create /run/user/$UID
user_run="/run/user/1000"
if [ ! -d $user_run ]; then
    sudo mkdir -p $user_run
    sudo chown chronos:chronos $user_run
fi

# Start Gentoo Prefix
if ! portageq envvar EPREFIX &>/dev/null; then
    export E=/usr/local/gentoo
    exec $E/startprefix
fi

# Start tmux
if which tmux &>/dev/null; then
    [ -z "$TMUX" ] && (tmux attach || tmux new-session)
fi

# Handle SSH agent
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
gpg-connect-agent updatestartuptty /bye &>/dev/null

# Go to home directory if at /
if [ $PWD = "/" ]; then
    cd
fi

# Enable globstar
shopt -s globstar
