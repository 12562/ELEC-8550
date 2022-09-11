#! /bin/csh

set num = "$argv"

if ( `echo $num | grep "\." | wc -l ` > 0 ) then
   set int = `echo $num | sed 's/\..*//g' | sed 's/-//g'`
   set frac = `echo $num | sed 's/.*\./\./g'`
else
   set int = `echo $num | sed 's/-//g'`
   set frac = .0
endif


echo $frac
set num_int = (`echo $int | sed 's/ */ /g'`)
if ( `echo $frac | sed 's/\.//g'`) then
   set num_frac = (`echo $frac | sed 's/ */ /g'`)
else
   set num_frac = 0
endif
echo "Num int : $num_int"

set i = `echo "-$#num_frac + 1" | bc -l` 
echo "Starting i : $i"
set negadecimal_num = ()

while ( $i <= $#num_int )
  if ( `echo "$i % 2" | sed 's/-//g' | xargs expr` && `echo "$num > 0" | bc -l` ) then
     set digit = `echo "$num * (10 ^ (-($i) - 1))" | bc -l | awk '{printf("%d\n",$1+1)}' | sed "s/\(.*\)/\(\1 - \($num * \(10 ^ \(-\($i\) - 1\)\)\)\) * 10/g" | bc -l | sed 's/\..*//g'`
     set num = `echo "$num * (10 ^ (-($i) - 1))" | bc -l | awk '{printf("%d\n",$1+1)}' | sed "s/\(.*\)/\1 \/ \(10 ^ \(-\($i\) - 1\)\)/g" | bc -l` 
  else if ( `echo "$i % 2" | sed 's/-//g' | xargs expr` == 0 && `echo "$num < 0" | bc -l` ) then
     set digit = `echo "$num * (10 ^ (-($i) - 1))" | bc -l | awk '{printf("%d\n",$1-1)}' | sed "s/\(.*\)/\(\1 - \($num * \(10 ^ \(-\($i\) - 1\)\)\)\) * 10/g" | bc -l | sed 's/\..*//g' | sed 's/-//g'`
     set num = `echo "$num * (10 ^ (-($i) - 1))" | bc -l | awk '{printf("%d\n",$1-1)}' | sed "s/\(.*\)/\1 \/ \(10 ^ \(-\($i\) - 1\)\)/g" | bc -l` 
  else
     set digit = `echo "($num * (10 ^ (-($i))))" | bc -l | sed 's/[^\.]*\([0-9]\)\.\?.*/\1/g'`
     set num   = `echo "$num * (10 ^ (-($i) - 1))" | bc -l | awk '{printf("%d\n",$1)}' | sed "s/\(.*\)/\1 \/ \(10 ^ \(-\($i\) - 1\)\)/g" | bc -l`    
  endif
  if ( $i == -1 ) then
     set negadecimal_num = ( . $digit $negadecimal_num)
  else
     set negadecimal_num = ( $digit $negadecimal_num)
  endif
  echo "$i :: $digit :: $num "
  set i = `echo "$i + 1" | bc -l`
end
echo $negadecimal_num | sed 's/ //g' | sed 's/^0*//g'
