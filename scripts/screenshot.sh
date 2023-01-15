mode=$1

case "$mode" in
    "fullscreen")
        filename="~/Pictures/Screenshot_$(date +%Y-%m-%dT%H-%M-%S).png"
        escrotum "$filename" 
        dunstify "escrotum" "Saved $filename"
        ;;
    "clip")
        escrotum -sC
        dunstify "escrotum" "Screenshot copied to clipboard"
        ;;
    "*")
        echo "invalid argument $mode"
        exit 1
        ;;
esac
