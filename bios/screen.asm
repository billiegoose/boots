
bios.clear_screen:
	pusha
	bios.cursor.moveto 0, 0
	bios.cursor.write_char 32
	; TODO, clear the whole screen lol
	mov cx, 80
@@:
	bios.cursor.moveto 0, cl
	bios.cursor.write_char 32
	loop @b
	popa
	ret