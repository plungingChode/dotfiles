# Disable greeting message
set --universal fish_greeting

# Enable vi key bindings
fish_vi_key_bindings

# Accept autosuggestions (even in vi mode) with Ctrl + S
bind --mode insert \cs "accept-autosuggestion"
bind \cs "accept-autosuggestion"

# Reapply fzf-fish bindings, since fzf's default overrides it for some
# reason.
bind \cr _fzf_search_history
bind -M insert \cr _fzf_search_history

function starship_transient_prompt_func
  starship module character
end
