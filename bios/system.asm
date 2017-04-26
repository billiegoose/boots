bios.wait_1s:			; 1 second = 1,000,000us = F4242h
	mov ah, 86h
	mov cx, 0Fh
	mov dx, 4240h
	int 15h
	ret

bios.wait_frame:		; 1/60 second = 16,666 = 411Ah
	mov ah, 86h		; flickers too much :/
	mov cx, 8h		; 1/2 second?
	mov dx, 4240h
	int 15h
	ret