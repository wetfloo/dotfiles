# Hide welcome message
set fish_greeting

# Set some environment variables (-x stands for environment)
set -x COLORTERM truecolor
set -x EDITOR nvim
set -x RUSTC_WRAPPER sccache
set -x TERMINAL alacritty

# Source modular config files
for file in ~/.config/fish/conf.d/*.fish
    source
end

#   if status is-interactive
#       # Configure auto-attach/exit to your likings (default is off).
#       set ZELLIJ_AUTO_ATTACH false
#       set ZELLIJ_AUTO_EXIT true
#       eval (zellij setup --generate-auto-start fish | string collect)
#   end
#   if not set -q ZELLIJ
#       if test "$ZELLIJ_AUTO_ATTACH" = "true"
#           zellij attach -c
#       else
#           zellij
#       end
#
#       if test "$ZELLIJ_AUTO_EXIT" = "true"
#           kill $fish_pid
#       end
#   end

# Apply .profile: use this to put fish compatible .profile stuff in
for file in .profile, .zprofil, .zprofile
    if test -f ~/$file
        source ~/$file 
    end
end

alias zall='eza -al --color=auto --group-directories-first --icons' # all files and dirs, long format
alias zal='eza -a --color=auto --group-directories-first --icons' # all files and dirs
alias zl='eza -l --color=auto --group-directories-first --icons' # long format
alias zt='eza -aT --color=auto --group-directories-first --icons' # tree listing
alias zd="eza -a | rg '^\.'" # show only dotfiles

alias fuz='cd ~ && cd $(fd . -t d | fzf)'
alias fuza='cd ~ && cd $(fd -H . -t d | fzf)'
