
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

# Show a progress bar with `notify-send`.
# 
# * appid - The app name and type of the progress bar. If not a valid progress
# bar kind, it will not be displayed.
#
# * message - Message to display inside the progress bar, usually an icon
# glyph.
#
# * actualValue - Current value of the progress bar. Will be scaled according
# to the [maxValue].
#
# * maxValue - (Optional) Maximum value possible to pass as [actualValue]. By
# default, this is 100.
#
function showProgressBar() {
    local appid=$1
    local message=$2
    local actualValue=$3
    local maxValue="${4:-100}"

    local idFile="${XDG_STATE_HOME}/${appid}.notification-id"

    # Handlers only accept values in the 0-100 range, so scale it accordingly
    local scaledValue=$(bc <<< "scale=2; ${actualValue}/${maxValue}*100")
    local scaledValue=$(bc <<< "scale=0; ${scaledValue}/1")

    local prevId=$(<"$idFile")
    if [ -z "$prevId" ]; then
        local prevId=1000
    fi

    notify-send \
        --app-name "$appid" \
        --urgency "low" \
        --expire-time 3000 \
        --replace-id "$prevId" \
        --print-id \
        --hint "string:synchronous:${appid}" \
        --hint "int:value:${scaledValue}" \
        "$message" \
    > "$idFile"

    return 0
}
