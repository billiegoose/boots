; Original code by Mike Gonta, Public Domain 2011
; https://board.flatassembler.net/topic.php?p=124387
use16
org 7C00h
bootloader_stage1:
  jmp .start
  nop
  db '        '
  dw 512                        ; bytes per sector
  db 1                          ; sectors per cluster
  dw 36                         ; reserved sector count
  db 2                          ; number of FATs
  dw 16*14                      ; root directory entries
  dw 18*2*80                    ; sector count
  db 0F0h                       ; media byte
  dw 9                          ; sectors per fat
  dw 18                         ; sectors per track
  dw 2                          ; number of heads
  dd 0                          ; hidden sector count
  dd 0                          ; number of sectors huge
  db 0                          ; drive number
  db 0                          ; reserved
  db 29h                        ; signature
  dd 0                          ; volume ID
  db '           '              ; volume label
  db 'FAT12   '                 ; file system type

.start:
  ; Hide blinking cursor
  mov ch, 10h
  mov cl, 00h
  mov ah, 01h
  int 10h

  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 7C00h

  mov bx, STAGE2_DEST_ADDRESS
  mov cx, 2                     ; track 0, sector 2
  xor dh, dh                    ; side 0
  mov ax, 223h 		; read 35 sectors
  ; Note: the BIOS sets dl to drive number of the boot device
  ; For USB hard drives it is 80h
  ; For USB floppy emulation it is 00h
  test dl, dl
  jne @f
  mov ax, 211h                  ; read 17 sectors
  call .read
  jc .exit
  add bx, 512*17
  mov cx, 1                     ; track 0, sector 1
  mov dh, 1                     ; side 1
  mov ax, 212h                  ; read 18 sectors
@@:
  call .read
  jc .exit

  jmp 0:STAGE2_DEST_ADDRESS

.read:
  mov bp, 2                     ; 3 tries
@@:
  push ax
  int 13h
  jnc @f
  sub bp, 1
  jc @f
  xor ax, ax
  int 13h
  pop ax
  jmp @b
@@:
  pop bp
  ret

.print:
  mov ah, 0Eh
  xor bh, bh
@@:
  mov al, [si]
  lea si, [si+1]
  test al, al
  je @f
  int 10h
  jmp @b
@@:
  ret

.exit:
  mov si, .boot_drive_read_error
  call .print
  mov ah, 10h
  int 16h
  int 19h

.boot_drive_read_error:
  db 'Boot drive read error!', 13, 10
  db 'Press any key to restart.', 13, 10, 0

.finish:
  times 510-($-$$)                db 0
                                  dw 0AA55h
