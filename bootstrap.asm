include 'bios/disk.inc'

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
	; mov ax, $
	; call print_ax
	
	; Demonstrate that the last two bytes of this sector ends with the signature AA55
	; mov ax, [7C00h + 510]
	; call print_ax
	
	; the bios loaded the first 512 bytes into RAM
	; at memory location 7C00 for us.
	; Specifically, it loaded:
	; - the first sector (of 18 sectors)
	; - of the first track (of 80 tracks)
	; - on the top side (of a two-sided disk)
	;
	; The majority of these first 512 bytes then must be dedicated
	; to loading the rest of the whopping 1.44MB floppy into
	; memory. A few bytes must be spared for error handling though.
	; Adjust ES register such that offset of 0 = address 7C00
	mov ax, 7C0h
	mov es, ax
address_loop:
	mov bx, 512 ; memory address # 0-FFFF
	mov cl, 2 ; sector # 1-18
	mov dh, 0 ; head # 0-1
	mov ch, 0 ; track # 0-79
	mov dl, 0 ; drive # (won't change)
bootstrap.start_of_loop:
	mov al, 1 ; number of sectors to copy
	mov ah, 02h
	int 13h
	jc bootstrap.disk_error
	add bx, 512
	cmp bx, 0FFFFh
	je bootstrap.rollover_segment
bootstrap.keep_going:
	add cl, 1
	cmp cl, 18 + 1
	jne bootstrap.start_of_loop		; next
	mov cl, 1				; reset sector to 1
	add dh, 1				; switch head (read opposite side of disk)
	cmp dh, 1 + 1
	jne bootstrap.start_of_loop
	mov dh, 0				; reset head to 0
	add ch, 1				; increment track
	cmp ch, 2; TODO: 80
	jne bootstrap.start_of_loop
	; reset ES register
	mov ax, 0
	mov es, ax
	
bootstrap.end_of_loading:
	jmp main

bootstrap.rollover_segment:
	mov ax, es
	add ax, 0FFFh
	mov es, ax
	mov bx, 0
	jmp bootstrap.keep_going

bootstrap.disk_error:
	mov dx, 0
	mov ds, dx
	mov si, bootstrap.disk_error_string	; source (string) address
	mov dx, 0b800h				; segment of screen
	mov es, dx
	mov di, 0				; dest (screen) address
						; repeat length-of-string times
	mov cx, bootstrap.endof_disk_error_string - bootstrap.disk_error_string
	rep movsb				; repeat move-string
	
bootstrap.print_ah:
	mov bx, ax	; make tmp copy
	mov si, bootstrap.hexdigits
	;mov ax, bx	; restore value from copy
	shr ax, 12
	add si, ax
	movsb		; copy string value at hexdigits+ax to di
	mov al, ' '
	stosb
	mov si, bootstrap.hexdigits
	mov ax, bx	; restore value from copy
	and ax, 00F00h
	shr ax, 8
	add si, ax
	movsb
	mov al, ' '
	stosb

bootstrap.spin:
	jmp $

bootstrap.disk_error_string:
	db 'E r r o r   h t t p s : / / e r r o r . d i r e c t o r y / B I O S # 1 3 '
bootstrap.endof_disk_error_string:
bootstrap.hexdigits:
	db '0123456789ABCDEF!'
	
fill_rest_with_zeros:
	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s

boot_signature:
	dw 0xAA55		; The standard PC boot signature