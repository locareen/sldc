#! /bin/bash
# checking
## check if this runnig as root
if [ $UID != 0 ]; then
    echo "You must run this with 'sudo -E'."
    exit 1
fi
## check if this runnig on sudo -E
if [ $HOME == "/root" ]; then
    echo "You must run this with 'sudo -E'."
fi
## please refer /usr/bin/sldc.
WORKDIR=$1
IMAGENAME=$2
MOUNTPOINT=$3
INITCOMMAND=$4
NOUMOUNT=$5
mkdir -p $MOUNTPOINT
mount -o loop,rw,offset=1048576 $WORKDIR/$IMAGENAME $MOUNTPOINT
xhost +local: > /dev/null
systemd-nspawn --setenv=DISPLAY=:0 \
--setenv=XAUTHORITY=~/.Xauthority \
--bind=/tmp/.X11-unix \
--bind-ro=$HOME/.Xauthority:/home/serene/.Xauthority \
--bind-ro=/etc/resolv.conf \
--hostname=SereneLinux-Basix \
--user=serene \
-D /mnt "$INITCOMMAND"
if [ $NOUMOUNT == "false" ]; then
    umount /mnt || echo "Cannot unmount /mnt" 1>&2
fi
