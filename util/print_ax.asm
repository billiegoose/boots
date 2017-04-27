
hexdigits db '0123456789ABCDEF!'

print_ax:	; print value of AX in hex
	pusha
	call print_ah
	call print_al
	popa
	ret
	
print_ah:	; print value of AH in hex
	pusha
	shr ax, 8
	call print_al
	popa
	ret

print_al:
	pusha
	mov bx, ax	; make tmp copy
	mov si, hexdigits
	mov ax, bx	; restore value from copy
	and ax, 00F0h
	shr ax, 4
	add si, ax
	lodsb
	bios.cursor.write_char al
	mov si, hexdigits
	mov ax, bx	; restore value from copy
	and ax, 000Fh
	add si, ax
	lodsb
	bios.cursor.write_char al
	popa
	ret
	
		
	
	
