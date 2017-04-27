; Using MikeOS tutorial as the starting point: http://mikeos.sourceforge.net/write-your-own-os.html
; Very basic bootloader

; tip: BIOS does not use ASCII but code page 437 (https://en.wikipedia.org/wiki/Code_page_437)
; resources:
; - https://en.wikibooks.org/wiki/X86_Assembly/Bootloaders

; Media: 1.44 MB floppy (emulation)
; This kind of floppy has: 80 tracks and 18 sectors / track.
; and is specifically listed as a drive type and media type combination
; supported by Phoenix BIOS 4.0

include 'bios/_macros.inc'
include 'util/_macros.inc'

; The original IBM PC BIOS loaded the 512 byte bootloader into memory starting at
; address 31,744. So of course that is what all PCs do to this day.
; Therefore our origin is 7C00h
org 07C00h

start:
	; The original bootloader is doing something clever
	; where it leaves its base address at 0 and uses the 20-bit
	; segmented addressing scheme of real mode to compensate.
	; It updates the Stack Segment and the Data Segment base addresses
	; to 7C0h (precisely 7C00h / 16) so that references to strings
	; etc fetch the right data.
	; Unless I need to relocate the bootloader using the bootloader,
	; I'm not sure why that would ever be advantageous, so I'm not
	; going to go that route for now. I think "org 7C00" is more
	; readily understood.
	; mov ax, 07C0h		; Set up 4K stack space after this bootloader
	; add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	; mov ss, ax
	; mov sp, 4096
	; mov ax, 07C0h		; Set data segment to where we're loaded
	; mov ds, ax

	; Demonstrate that this sector is loaded into ram
	; where I said it was.
	mov ax, $
	call print_ax
	
	; Demonstrate that the last two bytes of this sector ends with the signature AA55
	mov ax, [7C00h + 510]
	call print_ax

	bios.cursor.hide
	bios.cursor.moveto 0, 0
	call bios.clear_screen
	
	; load the 1st current sector to ram
	bios.cursor.moveto 1, 0
	bios.disk.sector.read 0, 0, 0, 1, 1, 7C00h + 512
	jc disk_error
	call print_ax
	mov si, 512 + string_data
	call print_string
	jmp main
	
disk_error:
	bios.cursor.moveto 24, 0
	mov si, disk_error_string
	call print_string
	call print_ah
	jmp $
	
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

inclusions:
	include 'bios/_routines.asm'
	include 'util/_routines.asm'
	
string_data:
	text_string db 'Welcome to WillOS! ', 0
	disk_error_string db 'Error https://error.directory/BIOS#13', 0
		
fill_rest_with_zeros:
	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
boot_signature:
	dw 0xAA55		; The standard PC boot signature