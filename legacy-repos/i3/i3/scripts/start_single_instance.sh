if [ $# -eq 0 ]; then
    echo 'missing app name to start'
fi

killall $1; $1
