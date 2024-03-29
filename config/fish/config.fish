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

# Apply .profile: use this to put fish compatible .profile stuff in
for file in .profile, .zprofil, .zprofile
    if test -f ~/$file
        source ~/$file
    end
end

# TODO: make this a bunch of functions with key args
alias zall='eza -al --color=auto --group-directories-first --icons' # all files and dirs, long format
alias zal='eza -a --color=auto --group-directories-first --icons' # all files and dirs
alias zl='eza -l --color=auto --group-directories-first --icons' # long format
alias zt='eza -aT --color=auto --group-directories-first --icons' # tree listing
alias zd="eza -a | rg '^\.'" # show only dotfiles

abbr -a gfb 'git checkout $(git branch --list --all --format="%(refname:short)" | fzf)'

alias fuz='cd ~ && cd $(fd . -t d | fzf)'
alias fuza='cd ~ && cd $(fd -H . -t d | fzf)'

for mode in $(bind --list-modes);
    bind \es --mode $mode 'tmux_sessionizer';
    bind \eS --mode $mode 'tmux_join /'
end

starship init fish | source
