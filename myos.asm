; Using MikeOS tutorial as the starting point: http://mikeos.sourceforge.net/write-your-own-os.html
; Very basic bootloader

; tip: BIOS does not use ASCII but code page 437 (https://en.wikipedia.org/wiki/Code_page_437)

; Media: 1.44 MB floppy (emulation)
; This kind of floppy has: 80 tracks and 18 sectors / track.
; and is specifically listed as a drive type and media type combination
; supported by Phoenix BIOS 4.0

include 'bios/_macros.inc'
include 'util/_macros.inc'

start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax
	
	bios.cursor.hide
	bios.cursor.moveto 0, 0
	call bios.clear_screen

main:
	bios.cursor.moveto 0, 0
	call bios.clear_screen
	bios.cursor.moveto 0, 0
	mov si, text_string	; Put string position into SI
	call print_string	; Call our string-printing routine
	bios.cursor.moveto 0, 72	; TODO 72
	call print_time		; Print current time

	call bios.wait_frame
	jmp main		; infinite loop

string_data:
	text_string db 'Welcome to WillOS! ', 0

inclusions:
	include 'bios/_routines.asm'
	include 'util/_routines.asm'

fill_rest_with_zeros:
	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature