macro display_decimal val {
  tmp = val
  ; Progressively make tmp smaller
  ; by dividing and print any non-zero digits
  if tmp / 100000 > 0
  	display '0' + (tmp / 100000)
    tmp = tmp - (tmp / 100000) * 100000
  end if
  if tmp / 10000 > 0
  	display '0' + (tmp / 10000)
    tmp = tmp - (tmp / 10000) * 10000
  end if
  if tmp / 1000 > 0
  	display '0' + (tmp / 1000)
    tmp = tmp - (tmp / 1000) * 1000
  end if
  if tmp / 100 > 0
  	display '0' + (tmp / 100)
    tmp = tmp - (tmp / 100) * 100
  end if
  if tmp / 10 > 0
    display '0' + (tmp / 10)
    tmp = tmp - (tmp / 10) * 10
  end if
  ; Always display 1s digit
  display '0' + tmp
}