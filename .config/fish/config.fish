if status is-interactive
    # Disable greeting message
    set --universal fish_greeting

    # Use icons in alacritty
    if test "$TERM" = "alacritty"
        alias ls="exa --icons"
    end

    alias ll="ls --long"
    alias la="ls --all"
    
    alias cp="cp -i"
    alias flux='xflux -l 47.497913 -g 19.040236'
    alias config-git='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    alias hx="helix"
    alias clip="xclip -selection clipboard"
    alias vimdiff="nvim -d"

    nvm --silent use 16
end

set --export VISUAL "nvim"
set --export EDITOR "nvim"
set --export BROWSER "firefox-developer-edition"
set --export BAT_THEME "Nord"
set --export DENO_INSTALL "$HOME/.deno"
set --export PATH_TO_FX "/usr/lib/jvm/java-11-openjfx/"
set --export ANDROID_HOME "$HOME/Android/Sdk"
set --export MANPAGER "less --RAW-CONTROL-CHARS --use-color -Dd+r -Du+b"
set --export PNPM_HOME "$HOME/.local/share/pnpm"
set --export SCRIPTS "$HOME/scripts"
set --export GOPATH "$HOME/.cache/yay/docker-git/src/go"

set --export PATH "$ANDROID_HOME/platform_tools:$DENO_INSTALL/bin:$SCRIPTS:$PNPM_HOME:$PATH"
# set --export PATH "$PATH:/usr/lib/jvm/java-8-openjdk/jre/bin/"
set --export PATH "$PATH:/usr/lib/jvm/java-17-openjdk/bin/"
set --export PATH "$PATH:$HOME/.local/share/flutter/bin/"
set --export PATH "$PATH:$HOME/.local/share/cmdline-tools/bin/"
set --export PATH "$PATH:$HOME/.local/share/cmdline-tools/bin/"

sh "$HOME/.cargo/env"

function fish_prompt
    set --local git_branch (git branch 2> /dev/null | sed -n '/\* /s///p')
    set --local cwd (pwd | sed s#^$HOME#~#)
    echo -ne "\n$cwd"
    if test -n "$git_branch"
        set_color cyan
        echo -n " ($git_branch)"
        set_color normal
    end
    set_color green
    echo -ne '\n$ '
    set_color normal
end

function fish_title
    set --local cwd (pwd | sed s#^$HOME#~#)
    echo $cwd
end
