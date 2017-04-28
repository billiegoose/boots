macro bios.disk.sector.read drive, head, track, sector, length, address {
    mov dl, drive
    mov dh, head
    mov ch, track
    mov cl, sector
    mov al, length
    mov ah, 02h
	mov bx, address
    int 13h
}