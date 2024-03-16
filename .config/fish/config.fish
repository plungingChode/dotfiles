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

# abbr docc docker 

#nvm --silent use 16

set --export VISUAL "nvim"
set --export EDITOR "nvim"
set --export BROWSER "firefox-developer-edition"
set --export BAT_THEME "Nord"
set --export DENO_INSTALL "$HOME/.deno"
set --export PATH_TO_FX "/usr/lib/jvm/java-11-openjfx/"
set --export ANDROID_HOME "$HOME/Android/Sdk"
set --export MANPAGER "bat --plain"
set --export PNPM_HOME "$HOME/.local/share/pnpm"
set --export SCRIPTS "$HOME/scripts"
set --export GOPATH "$HOME/.cache/yay/docker-git/src/go"

set --export PATH "$ANDROID_HOME/platform_tools:$DENO_INSTALL/bin:$SCRIPTS:$PNPM_HOME:$PATH"
# set --export PATH "$PATH:/usr/lib/jvm/java-8-openjdk/jre/bin/"
set --export PATH "$PATH:/usr/lib/jvm/java-17-openjdk/bin/"
set --export PATH "$PATH:$HOME/.local/share/flutter/bin/"
set --export PATH "$PATH:$HOME/.local/share/cmdline-tools/bin/"
set --export PATH "$PATH:$HOME/.local/share/cmdline-tools/bin/"
set --export HELLO "world"

# sh "$HOME/.cargo/env"

# Print full path as title
function fish_title
    set --local cwd (pwd | sed s#^$HOME#~#)
    echo "$cwd — fish"
end

# Prompt
function starship_transient_prompt_func
  starship module character
end
starship init fish | source
enable_transience
