#! /bin/csh

## To get n bit number in bsd, pipe this script n times. For the n=1, pass argument as "_"
set bit_arr = ( "1" "0" "-1")

foreach num ( $argv )
  echo $bit_arr | sed "s/\([^ ]*\)/\1$num/g"
end 
