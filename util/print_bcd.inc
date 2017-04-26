macro print_bcd.high x {
	push ax
	mov al, x
	shr al, 4		; get just high nibble
	add al, 30h		; add offset of '0' char
	bios.cursor.write_char al
	pop ax
}

macro print_bcd.low x {
	push ax
	mov al, x
	and al, 0Fh		; get just low nibble
	add al, 30h		; add offset of '0' char
	bios.cursor.write_char al
	pop ax
}
