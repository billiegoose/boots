; We always boot in 16-bit mode
use16

STAGE2_DEST_ADDRESS = 500h

; The original IBM PC BIOS loaded the first 512 bytes into RAM
; at memory location 7C00. So of course that is what all PCs do to this day.
; This tells the assembler where we are in memory.
org 07C00h
bootloader_stage1:
.start:
	; The bios loaded the first 512 bytes into RAM
	; at memory location 7C00 for us.
	; Specifically, it loaded:
	; - the first sector (of 18 sectors)
	; - of the first track (of 80 tracks)
	; - on the top side (of a two-sided disk)
	;
	; In an ideal world we would use this bootloader to load the
	; entire rest of the floppy disk into memory, but we simply
	; cannot. Tn 16bit real mode we can only address ~1MB,
	; and some of that is used by the BIOS and hardware.
	;
	; Unfortunately, we don't have room for the entire
	; floppy disk's 2880 sectors before we run into the
	; Extended BIOS Data Area (EBDA) and even the Video memory
	; So we must stop at 9FC00 where the EBDA begins
	;
	; Also, to address more than 2^16 bits we would have to do
	; a lot of manipulating the segment registers, and that
	; feature seems to be unreliable. My code worked great on qemu,
	; but not on bochs, would boot on my laptop, but not my desktop.
	;
	; So we're going to emulate the great bootloaders like GRUB, and
	; proceed through multiple successive stages.
	; This first stage will JUST load stage2 or print a pretty error.
	; We will need to know the length of our stage2 loader.
	; Luckily we can compute that by subtracting the labels
	; marking the start and end of stage2.

.address_loop:
	; We're going to load stage2 starting at address 500h
	; because http://wiki.osdev.org/Memory_Map_(x86) says
	; that 500h - 7FFFFh is guaranteed free for use.
	; We will stop long before overwriting our current location
	; 7C00h though.
	mov bx, STAGE2_DEST_ADDRESS ; memory address # 0-FFFF
	mov cl, 2 ; sector # 1-18 (or 1-9 for 720KB floppy)
	mov dh, 0 ; head # 0-1
	mov ch, 0 ; track # 0-79
	mov dl, 0 ; drive # (won't change)
	mov al, 8; TODO: uncomment this: (bootloader_stage2_end-bootloader_stage2)/512 + 1 ; number of sectors to copy
	mov ah, 02h
	int 13h
	jc .disk_error
	jmp STAGE2_DEST_ADDRESS
	
.disk_error:
	call .setup_screen_output
	mov si, .disk_error_string	; source (string) address
						; repeat length-of-string times
	mov cx, .endof_disk_error_string - .disk_error_string
	rep movsb				; repeat move-string
.print_ah:
	mov bx, ax	; make tmp copy
	mov si, .hexdigits
	;mov ax, bx	; restore value from copy
	shr ax, 12
	add si, ax
	movsb		; copy string value at hexdigits+ax to di
	mov al, ' '
	stosb
	mov si, .hexdigits
	mov ax, bx	; restore value from copy
	and ax, 00F00h
	shr ax, 8
	add si, ax
	movsb
	mov al, ' '
	stosb
.spin:
	jmp $
	
.setup_screen_output:
	mov dx, 0b800h			; Set up data index
	mov ds, dx			; to write to the screen
	mov di, 0			; address b8000
	ret
	
.disk_error_string:
	db 'E r r o r   h t t p s : / / e r r o r . d i r e c t o r y / B I O S # 1 3 '
.endof_disk_error_string:
.hexdigits:
	db '0123456789ABCDEF!'
.finish:


size_of_bootloader_stage1 = bootloader_stage1.finish - bootloader_stage1.start
display 0Ah
display "Bootloader is "
include '../util/display_decimal.inc'
display_decimal size_of_bootloader_stage1
display " bytes"
assert size_of_bootloader_stage1 <= 446

size_of_bootloader_stage2 = (bootloader_stage2_end-bootloader_stage2)/512 + 1
display 0Ah
display "Stage 2 is "
include '../util/display_decimal.inc'
display_decimal size_of_bootloader_stage2
display " sectors"
assert size_of_bootloader_stage2 <= 19
display 0Ah

.fill_rest_with_zeros:
	times 510-($-$$) nop	; Pad remainder of boot sector with nops

.boot_signature:
	dw 0xAA55		; The standard PC boot signature

;include 'enter_protected_mode.asm'