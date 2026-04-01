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

alias shizukustart='adb shell /data/app/~~zjlb9yl1jh2ZUm-gurEdOQ==/moe.shizuku.privileged.api-Orj9Hf7am-PiiO0PTswI6g==/lib/arm64/libshizuku.so'

alias rm='rm -i'

alias deq='xattr -d com.apple.quarantine'

alias tarcomp='tar -v -c -a -f'
alias tardecomp='tar -x -f'

alias decaf='killall -9 caffeinate'
function caf
	killall -q -9 caffeinate
	if test (count $argv) -eq 0
		caf -ism
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

function nvi
	nvim --cmd 'let g:lsp_status = 0' $argv
end

function sshpf -d "Port forward using ssh" -w "ssh" -a localport remoteport host
	if test (count $argv) -eq 0
		echo "Usage: sshpf <localport> <remoteport> <host>"
		return 1
	end

	ssh -fNL $localport:127.0.0.1:$remoteport $host
end

function extract --description "Extract various archive formats"
	if test (count $argv) -eq 0
		echo "Usage: extract <archive_file>"
		return 1
	end

	switch $argv[1]
	case '*.tar.bz2'
		tar xjf $argv[1]
	case '*.tar.gz'
		tar xzf $argv[1]
	case '*.bz2'
		bunzip2 $argv[1]
	case '*.rar'
		unrar x $argv[1]
	case '*.gz'
		gunzip $argv[1]
	case '*.tar'
		tar xf $argv[1]
	case '*.tbz2'
		tar xjf $argv[1]
	case '*.tgz'
		tar xzf $argv[1]
	case '*.zip'
		unzip $argv[1]
	case '*.Z'
		uncompress $argv[1]
	case '*.7z'
		7z x $argv[1]
	case '*'
		echo "Don't know how to extract '$argv[1]'"
		return 1
	end
end

# https://github.com/3rd/image.nvim/tree/4007cddc4cfc1b5ddd49744a38362e7b0432b3a0?tab=readme-ov-file#installing-imagemagick
#if type -q magick and type -q brew and [ "$(which magick)" = "$(brew --prefix)/bin/magick)" ]
#    set -x DYLD_LIBRARY_PATH "$(brew --prefix)/lib $DYLD_LIBRARY_PATH"
#end
