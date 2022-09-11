#! /bin/csh

set m = $argv

set i = 1
set j = 1
set k = 1
set bit_arr =  (-1 0 1)
set rep_arr = ( "" )
set new_rep_arr = ""

while ( $i <= $m )
  set ctr = 1
  set j = 1
  set new_rep_arr = ""
  while ( $j <= $#bit_arr ) 
    set k = 1
    while ( $k <= $#rep_arr ) 
      set new_rep_arr = "$bit_arr[$j]$rep_arr[$k] $new_rep_arr" 
      @ k = ( $k + 1 )
      @ ctr = ( $ctr + 1 )
    end
    @ j = ( $j + 1 ) 
  end
  set rep_arr = ( $new_rep_arr )
  @ i = ( $i + 1 )
end

echo $rep_arr
