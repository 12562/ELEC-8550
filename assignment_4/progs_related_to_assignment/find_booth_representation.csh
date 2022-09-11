#! /bin/csh


foreach num ( $argv ) 
set num_length = `echo $num | sed 's/ */ /g'`

set num1 = `echo "0${num}0"  | sed 's/ */ /g'`

set ctr = 1
set res = ""
while ($ctr < $#num1) 
   set ctr_plus_one = `echo $ctr + 1 | bc`
   set two_digits = "$num1[$ctr]$num1[$ctr_plus_one]"
   switch ( "$two_digits" ) 
        case "00": 
              set booth_bit = 0
              breaksw
        case "01": 
              set booth_bit = 1
              breaksw
        case "10": 
              set booth_bit = -1
              breaksw
        case "11": 
              set booth_bit = 0
              breaksw
   endsw
   set res = "${res}$booth_bit"
   @ ctr = ( $ctr + 1 )
end

echo $res
end
