print_time:			; Routine: output current time to screen in 00:00 format
	bios.clock.read
	print_bcd.high ch	; hours
	print_bcd.low ch
	bios.cursor.write_char ':'
	print_bcd.high cl	; minutes
	print_bcd.low cl
	bios.cursor.write_char ':'
	print_bcd.high dh	; seconds
	print_bcd.low dh
	ret