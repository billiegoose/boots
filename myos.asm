; Using MikeOS tutorial as the starting point: http://mikeos.sourceforge.net/write-your-own-os.html
; Very basic bootloader

; tip: BIOS does not use ASCII but code page 437 (https://en.wikipedia.org/wiki/Code_page_437)

include 'bios/10video.inc'
include 'util/print_bcd.inc'

start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax
	
	bios.hide_cursor
	bios.set_cursor 0, 0
	call bios.clear_screen

main:
	bios.set_cursor 0, 0
	call bios.clear_screen
	bios.set_cursor 0, 0
	mov si, text_string	; Put string position into SI
	call print_string	; Call our string-printing routine
	bios.set_cursor 0, 72	; TODO 72
	call print_time		; Print current time

	call bios.wait_frame
	jmp main		; infinite loop

string_data:
	text_string db 'Welcome to WillOS! ', 0

inclusions:
	include 'bios/10video.asm'
	include 'bios/15system.asm'
	include 'util/cstrings.asm'
	include 'util/print_time.asm'

fill_rest_with_zeros:
	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature