macro bios.clear_screen {
	; Clear the screen by writing to the video memory
	mov ax, es
	push ax
	mov ax, ds
	push ax
	mov eax, 0b800h
	mov es, ax		; where to write it pt 1
	mov ds, ax
	mov ax, 0h
	mov di, ax		; where to write it pt 2
	mov ah, [0b8001h]	; use current character attributes
	mov al, ' '		; value to write
	mov ecx, 80*25		; times to write it
	rep stosw
	pop ax
	mov es, ax
	pop ax
	mov ds, ax
}