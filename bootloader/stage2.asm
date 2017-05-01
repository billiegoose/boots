; These must be ONLY macros, no code
include 'bios/_macros.inc'
include 'util/_macros.inc'

; We're still in 16-bit mode
use16

; Stage 1 put us into RAM at address 500h.
; We can trust that, because we wrote stage1 ourselves.
org STAGE2_DEST_ADDRESS

bootloader_stage2:
	; Here we should presumably do awesome things like scan for a file
	; named "kernel.bin" in the floppy disk or something.
	
	; However, right now, I'm going to focus on getting us into protected
	; 32-bit mode.
	bios.cursor.hide
	;bios.clear_screen
	bios.cursor.moveto 0, 0
	mov si, .text_string	; Put string position into SI
	call .print_string	; Call our string-printing routine
	
	mov ah, 10h
	int 16h	
	jmp 0:main

.print_string:			; Routine: output string in SI to screen
	mov ah, 0Eh		; int 10h 'print char' function
@@:
	lodsb			; Get character from string
	cmp al, 0
	je @f		; If char is zero, end of string
	int 10h			; Otherwise, print it
	jmp @b
@@:
	ret

.text_string db 'Welcome to ', 0E1h, 148, 'ots! ', 13, 10, 'Press any key to continue...', 13, 10, 0
	
.includes:
	include 'bios/_routines.asm'
	include 'util/print_time.asm'
; This label is used to compute the # of sectors in stage2, which
; stage1 uses.
bootloader_stage2_end:

; fill up remainder of segment
align 512
