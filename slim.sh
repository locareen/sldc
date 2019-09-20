#! /bin/bash -e

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
## check if it takes only one argument
if [ $# != 1 ]; then
    echo "You must type only one argument."
    exit 1
fi
## check if depend softwares are installing
if ! type qemu-img >/dev/null 2>&1; then
    echo "qemu-img is not installing."
    echo "May be you must install qemu."
    exit 1
elif ! type xhost >/dev/null 2>&1; then
    echo "xhost is not installing."
    echo "May be you must install xorg-xhost."
    exit 1
fi
## check if not anything mounted on /mnt
if mountpoint -q /mnt; then
    echo "anything mounted on /mnt"
    echo "Please unmount."
    exit 1
fi
## check if the argument is correct
TYPE=${1##*.}
IMAGENAME=image.img
case "$TYPE" in
    "ova" )
        tar xvf $1
        VMDK=$(ls -m | tr ',' '\n' | grep *.vmdk)
        qemu-img convert -p -f vmdk -O raw $VMDK $IMAGENAME ;;

    "vdi" | "vmdk" | "qcow2" | "qed" | "vhd" )
        qemu-img convert -p -f $TYPE -O raw $1 $IMAGENAME ;;
    "img" )
        IMAGENAME=$1 ;;
    * )
        echo "This program supports format formats ova, vdi, vmdk, qcow2, qed, vhd and raw-img."
        echo "If you want to use excluding that, you must convert this to support format."
        exit 1 ;;
esac

MOUNTPOINT=/mnt
mkdir -p $MOUNTPOINT
mount -o loop,rw,offset=1048576 $IMAGENAME $MOUNTPOINT
xhost +local: > /dev/null
chmod 555 $MOUNTPOINT/home/serene/xinit.sh
systemd-nspawn --setenv=DISPLAY=:0 \
--setenv=XAUTHORITY=~/.Xauthority \
--bind=/tmp/.X11-unix \
--bind-ro=/etc/resolv.conf \
--user=serene -D /mnt /home/serene/xinit.sh
umount /mnt && echo "done!"
