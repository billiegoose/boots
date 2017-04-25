
; I like this, but it does involve two stack pushes/pops
; (one for ax and one for the instruction pointer)
bios.write_char:		; Just a friendly name for BIOS Service AH=0Eh int 10h
	push ax			; That also restores the a register
	mov ah, 0Eh
	int 10h
	pop ax
	ret

bios.clear_screen:
	pusha
	bios.set_cursor 0, 0
	mov cx, 70
@@:
	bios.set_cursor 0, cl		; FIXME: doesn't clear 1st column
	bios.write_char_mut_ax 32
	loop @b
	popa
	ret