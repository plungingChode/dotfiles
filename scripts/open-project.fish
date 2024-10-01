#!/bin/fish

set projects1 "$(find $HOME/source $HOME/personal -maxdepth 1 -mindepth 1 -type d)"
set projects2 "$(find $HOME/source/adsretail_api/fo/server/ $HOME/dotfiles -mindepth 0 -maxdepth 0 -type d)"
set newline '
'
set projects "$projects1$newline$projects2"

set project $(echo "$projects" | fzf)

if test -z "$project" 
    exit 0
end

set projectName $(basename "$project" | tr . _)
set isTmuxRunning $(pgrep tmux)

if test -z "$TMUX"; and test -z "$isTmuxRunning"
    tmux new-session -s "$projectName" -c "$project"
    exit 0
end

if test -n "$TMUX"
    cd $project
    exit 0
end

if not tmux has-session -t "$projectName" 2> /dev/null
    tmux new-session -d -s "$projectName" -c "$project"
end

tmux attach -t $projectName

