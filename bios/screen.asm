
bios.clear_screen:
	pusha
	bios.cursor.moveto 0, 0
	mov cx, 70
@@:
	bios.cursor.moveto 0, cl		; FIXME: doesn't clear 1st column
	bios.cursor.write_char 32
	loop @b
	popa
	ret