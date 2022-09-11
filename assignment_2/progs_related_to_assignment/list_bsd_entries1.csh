#! /bin/csh

set m = $argv

set i = 1
set j = 1
set k = 1
set bit_arr =  "-1 0 1"
set rep_arr =  "_"
set new_rep_arr = ""

while ( $i <= $m )
  set ctr = 1
  set j = 1
  set new_rep_arr = ""
  foreach j ( $bit_arr ) 
    foreach k ( $rep_arr )
      set new_rep_arr = "$j$k $new_rep_arr" 
    end
  end
  set rep_arr = "$new_rep_arr"
  @ i = ( $i + 1 )
end

echo $rep_arr
