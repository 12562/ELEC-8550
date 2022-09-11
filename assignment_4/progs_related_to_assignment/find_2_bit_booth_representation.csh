#! /bin/csh

set num_args =  $#argv
set lowerlimit = 1
set upperlimit = 100
if ( $upperlimit > $num_args) then
  set upperlimit = $num_args
endif
while ( $lowerlimit <= $num_args ) 
foreach num ( $argv[$lowerlimit-$upperlimit] ) 
set num_length = `echo $num | sed 's/ */ /g'`

if ( `echo "$#num_length % 2" | bc` ) then
   set temp_num = "0${num}0"
else
   set temp_num = "00${num}0"
endif
 
set num1 = `echo "$temp_num"  | sed 's/ */ /g'`

set ctr = 1
set res = ""
while ($ctr < $#num1) 
   set ctr_plus_one = `echo $ctr + 1 | bc`
   set ctr_plus_two = `echo $ctr + 2 | bc`
   set three_digits = "$num1[$ctr]$num1[$ctr_plus_one]$num1[$ctr_plus_two]"
   switch ( "$three_digits" ) 
        case "000": 
              set booth_bits = "00"
              breaksw
        case "001": 
              set booth_bits = "01"
              breaksw
        case "010": 
              set booth_bits = "01"
              breaksw
        case "011": 
              set booth_bits = "10"
              breaksw
        case "100":
              set booth_bits = "-10"
              breaksw
        case "101":
              set booth_bits = "0-1"
              breaksw
        case "110":
              set booth_bits = "0-1"
              breaksw
        case "111":
              set booth_bits = "00"
              breaksw
   endsw
   set res = "${res}$booth_bits"
   @ ctr = ( $ctr + 2 )
end

echo $res
end
set lowerlimit = `echo $lowerlimit + 100 | bc `
set upperlimit = `echo $lowerlimit + 100 | bc `
if ($upperlimit > $num_args) then
   set upperlimit = $num_args
endif
end
