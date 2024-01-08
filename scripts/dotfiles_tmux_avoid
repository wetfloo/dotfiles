#!/bin/bash

SESSION=$(tmux ls -F "#{session_name}" | rg -vs '^dotfiles$' | head -n 1)

if [[ -n "$SESSION" ]]; then
    tmux attach -t "$SESSION"
else
    tmux new-session
fi
