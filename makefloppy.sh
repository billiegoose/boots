# /usr/bin/env bash
set -e
NAME=myos
GITBASH="'/c/Program\ Files/Git/bin/bash'"
WINBASH='/c/Windows/System32/bash'
# Do a full clean and rebuild each time,
# avoiding the trouble that incremental Makefile
# builds that aren't aware of all dependencies can cause.
# @see Jonathan Blow's awesome compiler

#./makebin.sh

# Build blank floppy disk image, if it is missing.
if [ ! -f blank.img ]; then
	$WINBASH -c "mkfs.msdos -C blank.img 1440"
fi

# Copy assembled code to floppy disk boot sector
cp blank.img $NAME.img
$WINBASH -c "dd status=noxfer conv=notrunc if=$NAME.bin of=$NAME.img"

# Copy SBx file to disk
$WINBASH -c "dd status=noxfer conv=notrunc if=message.txt.sbx of=$NAME.img seek=4 bs=1024"
