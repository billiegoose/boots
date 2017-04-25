macro print_bcd_high op1 {
	push ax
	mov al, op1
	shr al, 4		; get just high nibble
	add al, 30h		; add offset of '0' char
	mov ah, 0Eh		; BIOS print char at cursor
	int 10h			; BIOS video service
	pop ax
}

macro print_bcd_low op1 {
	push ax
	mov al, op1
	and al, 0Fh		; get just low nibble
	add al, 30h		; add offset of '0' char
	mov ah, 0Eh		; BIOS print char at cursor
	int 10h			; BIOS video service
	pop ax
}
