# Disable greeting message
set --universal fish_greeting

# Use icons in alacritty
alias eza="eza --icons"
alias l="eza --classify"
alias la="eza --all"
alias ll="eza --long"
alias ls="eza"

alias cp="cp -i"
alias vi="nvim"
alias vim="nvim"
alias vimdiff="nvim -d"

# Abbreviations
abbr --add --position command docc "docker compose"

# Accept autosuggestions in vi mode with Ctrl + S
bind --mode insert \cs "accept-autosuggestion"
bind \cs "accept-autosuggestion"
bind --mode insert \cf "source $CUSTOM_SCRIPTS_DIR/open-project.fish; commandline -f repaint"
bind \cf "source $CUSTOM_SCRIPTS_DIR/open-project.fish; commandline -f repaint"

nvm --silent use 18

# Prompt
function starship_transient_prompt_func
  starship module character
end
starship init fish | source
enable_transience

fish_vi_key_bindings
