# /usr/bin/env bash
set -e
NAME=myos
GITBASH="'/c/Program\ Files/Git/bin/bash'"
WINBASH='/c/Windows/System32/bash'

./makefloppy.sh
dd if=$NAME.bin of=${NAME}.usb.img conv=notrunc
#qemu-system-i386 -boot a -fda $NAME.img # boot from floppy (ew...)
qemu-system-i386 -boot a -fda ${NAME}.usb.img # boot from floppy (ew...)
