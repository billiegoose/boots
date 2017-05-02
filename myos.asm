; A special thanks to these resources that helped me get started:
; - http://mikeos.sourceforge.net/write-your-own-os.html
; - https://en.wikibooks.org/wiki/X86_Assembly/Bootloaders
; Tip: BIOS does not use ASCII but code page 437 (https://en.wikipedia.org/wiki/Code_page_437)

; Media: 1.44 MB floppy (emulation)
; This kind of floppy has: 80 tracks and 18 sectors / track.
; and is specifically listed as a drive type and media type combination
; supported by Phoenix BIOS 4.0

; This is the bootloader. Very important.
include 'bootloader/index.asm'

; ====================================
; Now begins the post-bootloader era!!
;

include 'bios/_macros.inc'
include 'util/_macros.inc'
use16
main:
.locate_sbx:
	mov eax, 1
	mov bx, 1
  mov si, 9000h
  ;call SBx_locate_sector
	call SBx_assemble_archive
  mov si, .print_done
  call print_string
  bios.cursor.moveto 1, 0
  mov si, 9000h
	call print_string
	jmp $
	
.event_loop:
	; Fun silliness - swap o and ö back and forth
	mov al, [0b8018h]
	mov dl, [0b801Ah]
	mov [0b8018h], dl
	mov [0b801Ah], al
	bios.cursor.moveto 0, 72
	call print_time		; Print current time
	call bios.wait_frame
	jmp .event_loop		; infinite loop
	
	int 19h	; turn off computer
  
; 	; Debugging values (see which sectors loaded in RAM correctly)
; 	bios.cursor.moveto 0, 0
; 	call bios.clear_screen
; 	bios.cursor.moveto 2, 0
; 	rept 32 i:112 {
; 		mov ax, [7c00h + i*512]
; 		call print_ax
; 		bios.cursor.write_char ' '
; 	}
; 	; This works!
; 	call getAnswer
; 	call print_al
; 	bios.cursor.write_char ' '
; 	; This does not work... :/
; 	; It seems to not jump back to the right place.
; 	;call printAnswer
; 	;bios.cursor.write_char ' '
; 	; Print welcome message
; 	bios.cursor.moveto 0, 0
; 	call bios.clear_screen
; 	bios.cursor.moveto 0, 0
; 	mov si, text_string	; Put string position into SI
; 	call print_string	; Call our string-printing routine
; 
; event_loop:
; 	; Fun silliness - swap o and ö back and forth
; 	mov ax, [0b8018h]
; 	mov dx, [0b801Ah]
; 	mov [0b8018h], dx
; 	mov [0b801Ah], ax
; 	bios.cursor.moveto 0, 72
; 	call print_time		; Print current time
; 
; 	call bios.wait_frame
; 	jmp event_loop		; infinite loop
; 
; more_inclusions:
; 	;include 'bios/_routines.asm'
; 	include 'util/_routines.asm'
; 	include 'c_programs/answer.s'
; 
; more_string_data:
; 	text_string db 'Welcome to ', 0E1h, 148, 'ots! ', 0
; 
; 
; ; fill up a couple segments with numbers
; times 512*4-($-$$) db 33h	; Pad sector 1 with 1s
; rept 12 i:4 {
; 	times 512 db (i*16+i)	; Pad sector i with i's
; }
; rept 240 i:16 {
; 	times 512 db (i)	; Pad sector i with i's
; }
; ; keep in mind the output is little-endian so it looks wrong
; rept 2880-256 i:256 {
; 	times 256 dw i 		; Pad sector i with i's
; }
.print_done db 13, 10, 'Done.', 13, 10, 0
;include 'SBx/locate_sector.asm'
include 'SBx/assemble_archive.asm'
include 'util/print_ax.asm'