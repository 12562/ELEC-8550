#! /bin/csh

echo "Enter radix:"
set radix = "$<"
echo "Enter number:"
set num = "$<"
echo "Enter k:"
set k = "$<"
echo "Enter m:"
set m = "$<"
echo "Enter type of complement (radix : 0, diminished_radix : 1):"
set complement = "$<"

if ( $complement ) then
   set ulp = `echo $num | sed 's/-//g' |  sed 's/[0-9]/0/g' | sed 's/0$/1/g'`
   set complement_name = "Diminished radix complement: "
else
   set ulp = 0
   set complement_name = "Radix complement: "
endif

echo $ulp

if ( `echo $num | grep "\-" | wc -l ` > 0 ) then
  set r_to_power_k = `echo "$radix ^ $k" | bc -l`
  set dec_rep_of_number = `echo "$r_to_power_k - $ulp + $num " | bc -l`
else
  set dec_rep_of_number = `echo $num | sed 's/-//g'`
endif
set radix_rep_of_num = `csh decimal_to_base_a_conversion.csh $radix $dec_rep_of_number $k $m | grep "Base a" | awk -F ':' '{print $2}'`

set int_part = `echo $radix_rep_of_num | sed 's/\..*//g' | sed 's/\(.\)/\1 /g'`
set frac_part = `echo $radix_rep_of_num | sed 's/.*\.//g' | sed 's/\(.\)/\1 /g'`

if ( `echo $num | grep "\-" | wc -l ` > 0 ) then
  set sign = $int_part[1]
else
  set sign = 0
endif

set i = $#int_part
set j = $#frac_part

while ( $i < $k)
 set int_part = ( $sign $int_part) 
 @ i = ( $i + 1 )
end

while ( $j < $m )
  if ( $complement ) then
   set frac_part = ( $frac_part $sign ) 
  else
   set frac_part = ( $frac_part 0 )
  endif 
  @ j = ( $j + 1 )
end
echo -n "$complement_name "
echo "$int_part.$frac_part" | sed 's/ //g'
