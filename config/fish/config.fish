# Hide welcome message
set fish_greeting

fish_vi_key_bindings

# Set some environment variables (-x stands for environment)
set -x COLORTERM truecolor
set -x RUSTC_WRAPPER sccache
set -x TERMINAL kitty
set -x EDITOR nvim

# Source modular config files
for file in ~/.config/fish/conf.d/*.fish
    source
end

# Load os-specific stuff
for file in ~/.config/fish/os_local/*.fish
    source
end

# TODO: make this a bunch of functions with key args
alias zall='eza -al --color=auto --group-directories-first --icons' # all files and dirs, long format
alias zal='eza -a --color=auto --group-directories-first --icons' # all files and dirs
alias zl='eza -l --color=auto --group-directories-first --icons' # long format
alias zt='eza -aT --color=auto --group-directories-first --icons' # tree listing
alias zd="eza -a | rg '^\.'" # show only dotfiles

alias fuz='cd ~ && cd $(fd . -t d | fzf)'
alias fuza='cd ~ && cd $(fd -H . -t d | fzf)'

# fallback for when we're not in tmux
if not set -q $TMUX
    for mode in $(bind --list-modes);
        bind \ef --mode $mode 'set -x SHELL $(which fish); tmux_sessionizer';
        bind \es --mode $mode 'set -x SHELL $(which fish); tmux_join /'
    end
end

# find short options for commands
function manfind
    set -l cmd $argv[1]
    set -l arg $argv[2]

    man --pager="less -p \"\s\s+$arg\"" $cmd
end

starship init fish | source
