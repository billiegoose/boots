STAGE2_DEST_ADDRESS                      equ 600h
SIZE_OF_BOOTLOADER_STAGE2 = (bootloader_stage2_end-bootloader_stage2)/512 + 1

include 'stage1.asm'

size_of_bootloader_stage1 = bootloader_stage1.finish - bootloader_stage1.start
display 0Ah
display "Bootloader is "
include '../util/display_decimal.inc'
display_decimal size_of_bootloader_stage1
display " bytes"
assert size_of_bootloader_stage1 <= 446

include 'stage2.asm'

display 0Ah
display "Stage 2 is "
include '../util/display_decimal.inc'
display_decimal SIZE_OF_BOOTLOADER_STAGE2
display " sectors"
assert SIZE_OF_BOOTLOADER_STAGE2 <= 19
display 0Ah