#! /bin/csh

set num = $argv[1]
set num_int = `echo $num | sed 's/\..*//g' | sed 's/\([0-9]\)/\1 /g' | rev`

if ( `echo $num | grep "\." | wc -l ` > 0 ) then
  set num_frac = `echo $num | sed 's/.*\.//g' | sed 's/\([0-9]\)/\1 /g'`
else
  set num_frac = 0 
endif

if ( $#num_int > $#num_frac ) then
   set max = $#num_int
else
   set max = $#num_frac
endif

if ( $num_frac == 0 ) then
   set fractional_digits = 0
endif

echo $num_frac

set ctr = 0
set res = 0
while ( $ctr < $max )
   set index = `echo "$ctr + 1" | bc`
   if ( $index <= $#num_int ) then
      set integral_sum = `echo "$num_int[$index] * (-10 ^ "$ctr')'  | bc`
      echo "Integral sum : $integral_sum"
      set res = `echo "$res + $integral_sum " | bc -l `
   endif
   if ( $index <= $fractional_digits ) then
      set fractional_sum = `echo "$num_frac[$index] "'* ('"-10 ^ -"$index')' | bc -l | sed 's/0*$//g'`
      echo "Fractonal sum : $fractional_sum"
      set res = `echo "$res + $fractional_sum" | bc -l `
   endif
   echo $res
   @ ctr = ( $ctr + 1 )
end

echo $res
