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

	mov ah, 02h		; set cursor position
	mov dx, 0048h		; to 0, 72
	int 10h
	call print_time		; Print current time

	jmp main		; infinite loop

	text_string db 'Welcome to WillOS! ', 0

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
	print_bcd_high ch	; hours
	print_bcd_low ch
	mov al, 3Ah 		; ':'
	call bios.write_char
	print_bcd_high cl	; minutes
	print_bcd_low cl
	mov al, 3Ah 		; ':'
	call bios.write_char
	print_bcd_high dh	; seconds
	print_bcd_low dh
	ret

bios.write_char:		; Just a friendly name for BIOS Service AH=0Eh int 10h
	push ax			; That also restores the a register
	mov ah, 0Eh
	int 10h
	pop ax
	ret

	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature