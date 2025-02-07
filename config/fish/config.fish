# Hide welcome message
set fish_greeting

fish_vi_key_bindings

# Set some environment variables (-x stands for environment)
set -x COLORTERM truecolor
set -x RUSTC_WRAPPER sccache
set -x TERMINAL kitty
set -x EDITOR nvim

set -g fish_prompt_pwd_full_dirs 2
set -g fish_prompt_pwd_dir_length 3

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

alias shizukustart='adb shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh'

alias rm='rm -i'

# fallback for when we're not in tmux
if not set -q $TMUX
    for mode in $(bind --list-modes);
        bind \ef --mode $mode 'set -x SHELL $(which fish); tmux_sessionizer';
        bind \es --mode $mode 'set -x SHELL $(which fish); tmux_join /'
    end
end

if type -q fzf
    fzf --fish | source
end

# find short options for commands
function manfind
    set -l cmd $argv[1]
    set -l arg $argv[2]

    man --pager="less -p \"\s\s+$arg\"" $cmd
end

# https://github.com/3rd/image.nvim/tree/4007cddc4cfc1b5ddd49744a38362e7b0432b3a0?tab=readme-ov-file#installing-imagemagick
#if type -q magick and type -q brew and [ "$(which magick)" = "$(brew --prefix)/bin/magick)" ]
#    set -x DYLD_LIBRARY_PATH "$(brew --prefix)/lib $DYLD_LIBRARY_PATH"
#end

#if type -q luarocks
#    set -x LUA54_PATH "$(luarocks path --lr-path)"
#    set -x LUA54_CPATH "$(luarocks path --lr-cpath)"
#
#    # for compatibility with neovim
#    set -x LUA_PATH "$(luarocks path --lr-path --lua-version=5.1)"
#    set -x LUA_CPATH "$(luarocks path --lr-cpath --lua-version=5.1)"
#
#    set -l lr_path "$(luarocks path --lr-bin | sed 's/:/ /g')"
#    set -x PATH "$lr_path $PATH"
#end

set -g lucid_cwd_color $fish_color_normal
set -g lucid_prompt_symbol_color green
set -g lucid_prompt_symbol_error_color red
