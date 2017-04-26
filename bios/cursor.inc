macro bios.cursor.hide {
	pusha
	mov ch, 10h
	mov cl, 00h
	mov ah, 01h
	int 10h
	popa
}

macro bios.cursor.moveto x, y {
	pusha
	mov bh, 0		; page
	mov dh, x		; column
	mov dl, y		; row
	mov ah, 02h
	int 10h
	popa
}

macro bios.cursor.write_char c {
	pusha
	mov al, c
	mov ah, 0Eh
	int 10h
	popa
}
