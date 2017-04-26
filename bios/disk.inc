macro bios.read_sector drive, head, track, sector, length, address {
    pusha
    mov dl, drive
    mov dh, head
    mov ch, track
    mov cl, sector
    mov al, length
    mov ah, 02h
    int 13h
}