# Hide welcome message
set fish_greeting

fish_vi_key_bindings

# Set some environment variables (-x stands for environment)
set -x COLORTERM truecolor
set -x EDITOR nvim

set -g fish_prompt_pwd_full_dirs 2
set -g fish_prompt_pwd_dir_length 3

# Source modular config files
for file in ~/.config/fish/conf.d/*.fish
	source $file
end

# Load os-specific stuff
for file in ~/.config/fish/os_local/*.fish
	source $file
end

if type -q sccache
	set -x RUSTC_WRAPPER sccache
end

set -l os_name $(uname)
# Lazygit needs this to read the config from the correct directory
if [ $(uname) = 'Darwin' ]
	set -x XDG_CONFIG_HOME "$HOME/.config"
end

if type -q brew
	eval $(brew shellenv fish)
end

if test -d /opt/homebrew/opt/llvm
	set -x LDFLAGS "-L/opt/homebrew/opt/llvm/lib $LDFLAGS"
	set -x CPPFLAGS "-L/opt/homebrew/opt/llvm/include $CPPFLAGS"
end

if type -q nvim
	set -x MANPAGER "nvim +Man! -c 'set nospell'"
end

alias zall='eza -al --color=auto --group-directories-first --icons' # all files and dirs, long format
alias zal='eza -a --color=auto --group-directories-first --icons' # all files and dirs
alias zl='eza -l --color=auto --group-directories-first --icons' # long format
alias zt='eza -aT --color=auto --group-directories-first --icons' # tree listing
alias zd="eza -a | rg '^\.'" # show only dotfiles

if test -e "$HOME/.cargo/env.fish"
	source "$HOME/.cargo/env.fish"
end

function removepath
	if set -l index (contains -i $argv[1] $PATH)
		set --erase --universal fish_user_paths[$index]
		echo "Updated PATH: $PATH"
	else
		echo "$argv[1] not found in PATH: $PATH"
	end
end

alias shizukustart='adb shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh'

alias rm='rm -i'

alias decaf='killall -9 caffeinate'
function caf
	killall -q -9 caffeinate
	if test (count $argv) -eq 0
		caf -dism
	else
		nohup > /dev/null -- caffeinate $argv &
	end
	return 0
end

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

	man $cmd | less -p "^ +$arg"
end

function nvi
	nvim --cmd 'let g:lsp_status = 0' $argv
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
