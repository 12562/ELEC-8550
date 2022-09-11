#! /bin/csh

set num = "$argv"
set f = "0000_0000_0000_0000_0000_000"
set e = "0000_0000"

if ( `echo $num | grep "-" | wc -l ` > 0 ) then
   set num = `echo $num | sed 's/-//g'`
   set s = 1
else
   set s = 0
endif

set binary_num = `csh ../../assignment_1/scr_decimal_to_binary_conversion $num | grep Binary | awk -F ':' '{print $2}' | sed 's/^ //g'`

echo $binary_num
set integer_bits = `echo $binary_num | sed 's/\..*//g' | sed 's/^1/_/g'` 
set frac_bits = `echo $binary_num | sed 's/.*\.//g'`
echo "int bits : $integer_bits"
echo $frac_bits
if ( `echo $binary_num | grep "\..*1" | wc -l ` > 0 ) then
   set f_tmp = `echo $binary_num | sed 's/\.0*//g' | sed 's/^1//g' | sed 's/\(....\)/\1_/g'`
   echo $f_tmp
   set zeros_to_replace = `echo $binary_num | sed 's/\.0*//g' | sed 's/^1//g' | sed 's/\(....\)/\1_/g' | sed 's/1/0/g'`
else
   set f_tmp = `echo $binary_num | sed 's/\..*//g' | sed 's/^1//g' | sed 's/\(....\)/\1_/g'`
   set zeros_to_replace = `echo $binary_num | sed 's/\..*//g' | sed 's/^1//g' | sed 's/\(....\)/\1_/g' | sed 's/1/0/g'`
endif

set f = `echo $f | sed "s/^${zeros_to_replace}/$f_tmp/"`

if ( $integer_bits != "" ) then
   set decimal_e = `echo $integer_bits | sed 's/ */\n/g' | grep "0\|1" | wc -l | awk '{print $1}' | xargs echo "127 + " | bc`
else 
   set decimal_e = `echo $frac_bits | sed 's/ */\n/g' | grep "0\|1" | wc -l | awk '{print $1}' | xargs echo "127 - " | bc`
endif

set e_tmp = `csh ../../assignment_1/scr_decimal_to_binary_conversion $decimal_e | grep Binary | awk -F ':' '{print $2}' | sed 's/^ //g' | sed 's/\..*//g' | sed 's/\(....\)$/_\1/g'`
set zeros_to_replace = `echo $e_tmp | sed 's/1/0/g'`

set e = `echo $e | sed "s/${zeros_to_replace}"'$'"/$e_tmp/"`


echo "S : ${s}"
echo "E : ${e}"
echo "f : ${f}"
