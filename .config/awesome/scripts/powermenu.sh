#!/bin/bash

shutdown="󰐥"
reboot=""
lock=""
suspend="󰒲"
logout="󰍃"

options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"
confirm_script="$HOME/.config/awesome/scripts/confirm.sh"
lock_script="$HOME/.config/awesome/scripts/lock.sh"

chosen="$(echo -e "$options" | rofi -theme powermenu -dmenu -selected-row 2)"

case "$chosen" in
"$shutdown")
    ans=$("$confirm_script")
    [[ $ans == "y" ]] && systemctl poweroff
    ;;

"$reboot")
    ans=$("$confirm_script")
    [[ $ans == "y" ]] && systemctl reboot
    ;;

"$lock")
    "$lock_script"
    ;;

"$suspend")
    ans=$("$confirm_script")
    [[ $ans == "y" ]] && systemctl suspend -i
    ;;

"$logout")
    ans=$("$confirm_script")
    [[ $ans == "y" ]] && echo "awesome.quit()" | awesome-client
    ;;
esac
