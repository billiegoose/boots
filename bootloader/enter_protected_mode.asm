; Time to exit the world of 16-bit "real mode" and
; enter the glorious world of 32-bit programming!
;
; as always, much thanks to wiki.osdev.org
;
macro make_segment_descriptor base, limit, prototype {
  dq (((limit and 0x000F0000) or \
       ((prototype shl 8) and 0x00F0FF00) or \
       ((base shr 16) and 0x000000FF) or \
       (base and 0xFF000000)) \
      shl 32) \
     or ((base shl 16) or \
         (limit and 0x0000FFFF))
}

; Behold! The incredibly lazy, zero read/write/access protections Global Descriptor Table
; that just labels 0 to FFFFFFFF (4GiB) of RAM.
; TODO: Make permissions more granular
gdt:
dq 0x0000000000000000
dq 0x00CF9A001000FFFF
dq 0x00CF92001000FFFF
dq 0x00CFFA001000FFFF
dq 0x00CFF2001000FFFF
gdt_end:
; TODO: Create a TSS so we can get to ring 3

; And yet more! We need a special bastardized pointer thing for the 'lgdt' command
gdtr	dw 0
	dd 0

; None of this would be possible without wiki.osdev.org/GDT_Tutorial
set_gdt:
	xor eax, eax
	mov ax, ds
	shl eax, 4
	add eax, gdt
	mov dword [gdtr + 2], eax
	mov eax, gdt_end
	sub eax, gdt
	mov [gdtr], ax
	lgdt fword [gdtr]
	ret

reloadSegments:
	; reload cs register containing code selector:
	jmp   8h:reload_cs ; 0x08 points at the new code selector
reload_cs:
	; reload data segment registers:
	mov   eax, 10h ; 0x10 points at the new data selector
	mov   ds, ax
	mov   es, ax
	mov   fs, ax
	mov   gs, ax
	mov   ss, ax
	ret
 
enter_protected_mode:
	cli          ; clear interrupts
	mov ax, 0
	mov ds, ax
	call set_gdt ; load GDT register with start address of Global Descriptor Table
	mov eax, cr0
	or eax, 1     ; set PE (Protection Enable) bit in CR0 (Control Register 0)
	mov cr0, eax
	;smsw ax
	;or ax,1
	;lmsw ax
	; Perform far jump to selector 08h (offset into GDT, pointing at a 32bit PM code segment descriptor) 
	; to load CS with proper PM32 descriptor)
	call reloadSegments
	jmp main
	