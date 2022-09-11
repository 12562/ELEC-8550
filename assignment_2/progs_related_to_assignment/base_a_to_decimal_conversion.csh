#! /bin/csh

set base = $argv[1]
set num_args = $#argv 
set i = 2
while ( $i <= $num_args )
  set lowerlimit = $i
  set upperlimit = `echo $i + 100 | bc`
  #echo "$lowerlimit $upperlimit"
  if ( $upperlimit > $num_args ) then
    set upperlimit = $num_args
  endif


   foreach num ( $argv[$lowerlimit-$upperlimit] )
      set ctr = `echo $num | sed 's/\..*//g' | grep -o "[0-9A-F]" | wc -l`
      set ctr = `expr $ctr - 1`
      set i = 0
      set sum = 0
      foreach d ( `echo $num | sed 's/\.//g' | sed 's/\([0-9A-F]\)/\1 /g' ` )
        if ( `echo $d | grep "[A-F]" | wc -l ` > 0 ) then
           set d = `echo $d | tr 'A-F' '0-5' | sed 's/^/1/g'`
        endif
        set sum = `echo "($sum + ($d * ($base ^ $ctr)))" | bc -l`
        echo $sum
        @ ctr = ( $ctr - 1 )
        @ i = ( $i + 1 )
      end
      echo $num
      echo "$num : $sum"
   end
   set i = `echo $i + 100 | bc`
end
