# /usr/bin/env bash
set -e
NAME=myos
GITBASH="'/c/Program\ Files/Git/bin/bash'"
WINBASH='/c/Windows/System32/bash'

./makefloppy.sh
qemu-system-i386 -boot a -fda $NAME.img # boot from floppy (ew...)
#qemu-system-i386 -boot d -cdrom $NAME.iso # boot from CD