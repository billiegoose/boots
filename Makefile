NAME=myos
GITBASH="'/c/Program\ Files/Git/bin/bash'"
WINBASH='/c/Windows/System32/bash'

%.bin : %.asm
	fasm $(NAME).asm $(NAME).bin

%.img : %.bin blank.img
	cp blank.img $(NAME).img
	$(WINBASH) -c "dd status=noxfer conv=notrunc if=$(NAME).bin of=$(NAME).img"

%.iso : %.img
	mkdir -p cdiso
	cp $(NAME).img cdiso
	$(WINBASH) -c "mkisofs -o $(NAME).iso -b $(NAME).img cdiso/"

$(NAME) : $(NAME).iso
	rm -rf cdiso

blank.img :
	$(WINBASH) -c "mkfs.msdos -C blank.img 1440"


clean:
	rm -f myos.iso myos.img trace-*
