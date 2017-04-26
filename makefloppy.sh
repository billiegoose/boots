# /usr/bin/env bash
NAME=myos
GITBASH="'/c/Program\ Files/Git/bin/bash'"
WINBASH='/c/Windows/System32/bash'

# Do a full clean and rebuild each time,
# avoiding the trouble that incremental Makefile
# builds that aren't aware of all dependencies can cause.
# @see Jonathan Blow's awesome compiler

# Clean
rm -f $NAME.iso $NAME.img $NAME.bin trace-*

# Assemble
fasm $NAME.asm $NAME.bin

# Build blank floppy disk image, if it is missing.
if [ ! -f blank.img ]; then
	$WINBASH -c "mkfs.msdos -C blank.img 1440"
fi

# Copy assembled code to floppy disk boot sector
cp blank.img $NAME.img
$WINBASH -c "dd status=noxfer conv=notrunc if=$NAME.bin of=$NAME.img"
