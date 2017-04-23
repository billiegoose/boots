NAME=myos
GITBASH="'/c/Program\ Files/Git/bin/bash'"
WINBASH='/c/Windows/System32/bash'

%.bin : %.asm
	fasm $(NAME).asm $(NAME).bin
	
%.flp : %.bin blank.flp
	cp blank.flp $(NAME).flp
	$(WINBASH) -c "dd status=noxfer conv=notrunc if=$(NAME).bin of=$(NAME).flp"
	
%.iso : %.flp
	mkdir -p cdiso
	cp $(NAME).flp cdiso
	$(WINBASH) -c "mkisofs -o $(NAME).iso -b $(NAME).flp cdiso/"

$(NAME) : $(NAME).iso
	rm -rf cdiso
	
blank.flp :
	$(WINBASH) -c "mkfs.msdos -C blank.flp 1440"


clean:
	rm -f myos.iso trace-*