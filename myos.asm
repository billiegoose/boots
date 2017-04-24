; Using MikeOS tutorial as the starting point: http://mikeos.sourceforge.net/write-your-own-os.html
; Very basic bootloader

; tip: BIOS does not use ASCII but code page 437 (https://en.wikipedia.org/wiki/Code_page_437)

start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax
	
	; hide cursor
	mov ch, 10h
	mov cl, 00h
	mov ah, 01h
	int 10h

main:
	mov ah, 02h		; Set cursor position
	mov dx, 0h		; to 0,0
	int 10h			; BIOS video service
	mov si, text_string	; Put string position into SI
	call print_string	; Call our string-printing routine

	call print_time		; Print current hour

	jmp main		; infinite loop


	text_string db 'Welcome to WillOS! ', 0


print_string:			; Routine: output string in SI to screen
	mov ah, 0Eh		; int 10h 'print char' function

.repeat:
	lodsb			; Get character from string
	cmp al, 0
	je .done		; If char is zero, end of string
	int 10h			; Otherwise, print it
	jmp .repeat

.done:
	ret

print_time:			; Routine: output current time to screen in 00:00 format
	mov ah, 02h		; Select "Read real time clock" service
	int 1ah			; BIOS Time of Day Services interupt
	; Hx:xx:xx
	mov al, ch		;
	shr al, 4
	add al, 30h
	call bios.write_char
	; xH:xx:xx
	mov al, ch
	and al, 0fh
	add al, 30h
	call bios.write_char
	
	mov al, 3Ah ; ':'
	call bios.write_char
	
	; xx:Mx:xx
	mov al, cl		;
	shr al, 4
	add al, 30h
	call bios.write_char
	; xx:xM:xx
	mov al, cl
	and al, 0fh
	add al, 30h
	call bios.write_char
	
	mov al, 3Ah ; ':'
	call bios.write_char
	
	; Get MSD of seconds
	; xx:xx:Sx
	mov al, dh		; Move "seconds" BCD to A register
	shr al, 4		; get 10s digit nibble
	add al, 30h		; Add ASCII offset to '0'
	call bios.write_char	; Print 10s seconds
	; xx:xx:xS
	mov al, dh		; Move "seconds" BCD to A register
	and al, 0Fh		; get 1s digit nibble
	add al, 30h		; Add ASCII offset to '0'
	call bios.write_char	; Print 1s seconds
	ret

bios.write_char:		; Just a friendly name for BIOS Service AH=0Eh int 10h
	push ax			; That also restores the a register
	mov ah, 0Eh
	int 10h
	pop ax
	ret

	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature