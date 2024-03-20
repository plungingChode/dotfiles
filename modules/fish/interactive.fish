# Disable greeting message
set --universal fish_greeting

# Enable vi key bindings
fish_vi_key_bindings

# Accept autosuggestions (even in vi mode) with Ctrl + S
bind --mode insert \cs "accept-autosuggestion"
bind \cs "accept-autosuggestion"

function starship_transient_prompt_func
  starship module character
end
