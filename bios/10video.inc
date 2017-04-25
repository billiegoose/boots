macro bios.write_char_mut_ax c {
	pusha
	mov al, c
	mov ah, 0Eh
	int 10h
	popa
}

macro bios.hide_cursor {
	pusha
	mov ch, 10h
	mov cl, 00h
	mov ah, 01h
	int 10h
	popa
}

macro bios.set_cursor x, y {
	pusha
	mov bh, 0		; page
	mov ah, 02h		; set cursor position
	mov dh, x		; column
	mov dl, y		; row
	int 10h
	popa
}
