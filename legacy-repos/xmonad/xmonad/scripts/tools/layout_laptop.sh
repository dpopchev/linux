laptop='eDP-1'
while IFS= read -r screen; do
    [[ $screen != $laptop ]] && xrandr --output $screen --off
done < <(xrandr --listactivemonitors | grep -oP '\b\w+-\d$')

xrandr | grep $laptop | grep primary &> /dev/null
[ $? -ne 0 ] && xrandr --output $laptop --primary --auto
