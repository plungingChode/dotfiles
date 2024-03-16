
function exponentialCurveX() {
    local y=$1
    if (( $y < 10 )); then
        echo "1"
    elif (( $y < 30 )); then
        echo "3"
    elif (( $y < 60 )); then
        echo "5"
    else
        echo "7"
    fi
}
