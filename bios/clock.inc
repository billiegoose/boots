macro bios.clock.read {
    mov ah, 02h		; Select "Read real time clock" service
	int 1ah			; BIOS Time of Day Services interupt
}