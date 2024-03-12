# Disable greeting message
set --universal fish_greeting

# Accept autosuggestions in vi mode with Ctrl + S
bind --mode insert \cs "accept-autosuggestion"
bind \cs "accept-autosuggestion"

set --export BEMENU_OPTS "\
    --fn 'FiraCode Nerd Font 14' \
    --bottom \
    --hp 10 \
    --line-height 30 \
    --tb '#2b303b' \
    --tf '#81a1c1' \
    --fb '#2b303b' \
    --ff '#eceff4' \
    --sb '#2b303b' \
    --sf '#eceff4' \
    --nb '#2b303b' \
    --nf '#eceff4' \
    --ab '#2b303b' \
    --af '#eceff4' \
    --hb '#2b303b' \
    --hf '#81a1c1' 
";


function starship_transient_prompt_func
  starship module character
end
