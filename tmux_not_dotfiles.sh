#!/bin/bash

SESSION=$(tmux ls -F "#{session_name}" | rg -vs '^dotfiles$' | head -n 1)

if [[ $($SESSION | wc -c) -gt 0 ]]; then
    tmux attach -t $SESSION
else
    tmux new-session
fi
