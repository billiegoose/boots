print_time:			; Routine: output current time to screen in 00:00 format
	mov ah, 02h		; Select "Read real time clock" service
	int 1ah			; BIOS Time of Day Services interupt
	print_bcd_high ch	; hours
	print_bcd_low ch
	mov al, 3Ah 		; ':'
	call bios.write_char
	print_bcd_high cl	; minutes
	print_bcd_low cl
	mov al, 3Ah 		; ':'
	call bios.write_char
	print_bcd_high dh	; seconds
	print_bcd_low dh
	ret