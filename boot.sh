# /usr/bin/env bash
NAME=${1:-myos}
# qemu-system-i386 -boot a -fda $NAME.flp # boot from floppy (ew...)
qemu-system-i386 -boot d -cdrom $NAME.iso # boot from CD