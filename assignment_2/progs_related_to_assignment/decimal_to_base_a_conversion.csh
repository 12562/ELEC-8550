#! /bin/csh

set base = "$argv[1]"
set decimal_value = "$argv[2]"
set k = "$argv[3]"
set m = "$argv[4]"
if ( `echo $decimal_value | grep "\." | wc -l ` > 0 ) then
   set int = `echo $decimal_value | sed 's/\..*//g'`
   set frac = `echo $decimal_value | sed 's/.*\./0\./g'`
else
   set int = $decimal_value
   set frac = 0
endif

echo $int
set quo = $int
set binary_int = ()
while ( $quo != 0 )
  set rem = `echo "$quo % $base"  | bc | sed 's/-//g'`
  set quo = `echo "$quo / $base"  | bc`
  set binary_int = ( $rem $binary_int )
end

echo $frac
if ( $frac != 0 ) then
   set fractional = $frac
   set binary_frac = ()
   set ctr = 0
   while ( $ctr < $m && $fractional != 0 ) 
     set integral   = `echo "$fractional * $base" | bc | sed 's/^\./0\./g' | sed 's/\..*//g'`
     set fractional = `echo "$fractional * $base" | bc | sed 's/.*\./0\./g' | sed 's/\.\?0\+$//g'`
     set binary_frac = ( $binary_frac $integral )
     @ ctr = ( $ctr + 1 )
   end
else
   set binary_frac = "0"
endif


set representation = `echo $binary_int.$binary_frac | sed 's/ //g'`

echo "Base a representation : $representation"
echo "#Integer bits : $#binary_int"
echo "#Fractional bits : $#binary_frac"
