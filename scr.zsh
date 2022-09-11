#!/bin/env zsh

#dependencies: pdftk, ImageMagick, gpg, wipe, openssl

signature=/home/mohit/Downloads/my_data/mohit_sign.jpg

f=${1%.pdf}
page=$2
density=144
bo=0.2 #baseline overlap in relation to y-size of the signature

pagecount=$(pdftk $f.pdf dump_data | grep NumberOfPages | sed "s/.*: //")
#sign on last page by default
if [ -z "$page" ]; then page=$pagecount; fi

function cleanup
{
    echo "Cleaning up..."
    rm $f.$page.pdf
    wipe $f.$page.signature.pdf $f.$page.signed.pdf $f.signed.pdf signature.png
}
trap cleanup EXIT

echo "Signing document $f.pdf on page $page."

echo "Decrypting signature..."
gpg -d $signature > signature.png
identity=$(identify -format "%w,%h,%x,%y" signature.png)
sdata=(${(s/,/)identity})

echo "Please give the signature area with two clicks and finish by pressing ‘q’!"

#extract page
pdftk $f.pdf cat $page output $f.$page.pdf
cp $f.$page.pdf $f.$page.signed.pdf
size=$(identify -format "%wx%h" $f.$page.pdf)

#select signature area
display -density $sdata[3]x$sdata[4] -immutable -alpha off -update 1 -debug X11 -log "%e" -title "sign $f.pdf#$page" $f.$page.signed.pdf 2>&1 >/dev/null | \
    grep --line-buffered "Button Press" | \
    stdbuf -oL sed -r "s/^.*\+([0-9]+)\+([0-9]+).*$/\1,\2/" | \
    while read line
do
    p1=($p2)
    p2=(${(s/,/)line})

    if [ -n "$p1" ]
    then
        p=(0 0)
        if (( p1[1] < p2[1] )); then dx=$((p2[1]-p1[1])); p[1]=$p1[1]; else dx=$((p1[1]-p2[1])); p[1]=$p2[1]; fi
        if (( p1[2] < p2[2] )); then dy=$((p2[2]-p1[2])); p[2]=$p1[2]; else dy=$((p1[2]-p2[2])); p[2]=$p2[2]; fi
        dy=$((dy*(1+bo)))

        if (( $dx*$sdata[2] > $sdata[1]*$dy ))
        then
            resize=$(((dy+0.0)/sdata[2]))
            p[1]=$((p[1]+(dx-resize*sdata[1])/2))
        else
            resize=$(((dx+0.0)/sdata[1]))
            p[2]=$((p[2]+(dy-resize*sdata[2])/2))
        fi

        echo "Inserting signature..."
        convert -density $density -size $size xc:transparent \( signature.png -resize $((resize*100))% \) -geometry +$p[1]+$p[2] -composite $f.$page.signature.pdf
        pdftk $f.$page.pdf stamp $f.$page.signature.pdf output $f.$page.signed.pdf

        unset p1 p2
    fi
done

if [ -z "$p" ]
then
    echo "You have to click two times. Aborting..."
    exit 1
fi

echo "Joining PDF pages..."
sew=( pdftk A=$f.pdf B=$f.$page.signed.pdf cat )
if (( page > 1 )); then
    sew+=A1-$((page-1))
fi
sew+=B
if (( page < pagecount )); then
    sew+=A$((page+1))-end
fi
sew+=( output $f.signed.pdf )
$sew

echo "Encrypting PDF file..."
pdftk $f.signed.pdf output $f.signenc.pdf user_pw PROMPT owner_pw $(openssl rand -base64 32) allow AllFeatures
