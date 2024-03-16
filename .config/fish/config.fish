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

# nvm --silent use 16

# Print full path as title
# function fish_title
#     set --local cwd (pwd | sed s#^$HOME#~#)
#     echo "$cwd — fish"
# end

# Prompt
function starship_transient_prompt_func
  starship module character
end
starship init fish | source
enable_transience

fish_vi_key_bindings
