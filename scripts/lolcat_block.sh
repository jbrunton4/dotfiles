#!/bin/bash

n_chars="$(( "$LINES" * "$COLUMNS" ))"

str=""
for ((i=0; i<$LINES; i++)); do
    for ((j=0; j<$COLUMNS; j++)); do
        str="${str}█"
    done
    [ $i -ne $(($LINES - 1)) ] && str="${str}\n"
done

echo -e -n $str | lolcat
read -n 1