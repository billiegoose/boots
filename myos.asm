; A special thanks to these resources that helped me get started:
; - http://mikeos.sourceforge.net/write-your-own-os.html
; - https://en.wikibooks.org/wiki/X86_Assembly/Bootloaders
; Tip: BIOS does not use ASCII but code page 437 (https://en.wikipedia.org/wiki/Code_page_437)

; Media: 1.44 MB floppy (emulation)
; This kind of floppy has: 80 tracks and 18 sectors / track.
; and is specifically listed as a drive type and media type combination
; supported by Phoenix BIOS 4.0

; This is the first 512 bytes. Very important.
include 'bootstrap.asm'

; ====================================
; Now begins the post-bootloader era!!
;

include 'bios/_macros.inc'
include 'util/_macros.inc'

main:
	bios.cursor.hide
	
	; Debugging values (see which sectors loaded in RAM correctly)
	bios.cursor.moveto 0, 0
	call bios.clear_screen
	bios.cursor.moveto 2, 0
	rept 32 i:112 {
		mov ax, [7c00h + i*512]
		call print_ax
		bios.cursor.write_char ' '
	}
	
	; Print welcome message
	bios.cursor.moveto 0, 0
	call bios.clear_screen
	bios.cursor.moveto 0, 0
	mov si, text_string	; Put string position into SI
	call print_string	; Call our string-printing routine

event_loop:
	; Fun silliness - swap o and ö back and forth
	mov ax, [0b8018h]
	mov dx, [0b801Ah]
	mov [0b8018h], dx
	mov [0b801Ah], ax
	bios.cursor.moveto 0, 72
	call print_time		; Print current time

	call bios.wait_frame
	jmp event_loop		; infinite loop

more_inclusions:
	include 'bios/_routines.asm'
	include 'util/_routines.asm'

more_string_data:
	text_string db 'Welcome to ', 0E1h, 148, 'ots! ', 0


; fill up a couple segments with numbers
times 512*3-($-$$) db 22h	; Pad sector 1 with 1s
rept 13 i:3 {
	times 512 db (i*16+i)	; Pad sector i with i's
}
rept 240 i:16 {
	times 512 db (i)	; Pad sector i with i's
}
; keep in mind the output is little-endian so it looks wrong
rept 2880-256 i:256 {
	times 256 dw i 		; Pad sector i with i's
}
