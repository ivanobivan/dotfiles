#!/bin/bash

yes=" Yes"
no=" No"

chosen="$(echo -e "$yes\n$no" | rofi -theme confirm -dmenu)"

if [[ $chosen == $yes ]]; then
    echo 'y'
elif [[ $chosen == $no ]]; then
    echo 'n'
else
    echo 'c'
fi
