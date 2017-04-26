# /usr/bin/env bash
NAME=myos
GITBASH="'/c/Program\ Files/Git/bin/bash'"
WINBASH='/c/Windows/System32/bash'

./makefloppy.sh

mkdir -p cdiso
cp $NAME.img cdiso
$WINBASH -c "mkisofs -o $NAME.iso -b $NAME.img cdiso/"

rm -rf cdiso