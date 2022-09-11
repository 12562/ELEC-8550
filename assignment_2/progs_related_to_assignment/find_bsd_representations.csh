#! /bin/csh

set binary_num = $argv
echo $binary_num
set new_bsd_num = ( "$binary_num" )
set i = 0

while ( `grep 01 $binary_num` > 0 ) 
     set new_binary_num = echo $binary_num | sed 's/01/1\-1/'
     echo $new_binary_num
end
     
while ( `grep "0\-1" $binary_num` > 0 )
     set new_binary_num2 = echo $binary_num | sed 's/0\-1/\-11/g'
