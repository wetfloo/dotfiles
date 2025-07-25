# Default appearance options. Override in config.fish if you want.
if ! set -q lucid_dirty_indicator
	set -g lucid_dirty_indicator "•"
end

if ! set -q lucid_prompt_symbol
	set -g lucid_prompt_symbol ">"
end

if ! set -q lucid_prompt_symbol_error
	set -g lucid_prompt_symbol_error ">"
end

# This should be set to be at least as long as lucid_dirty_indicator, due to a fish bug
if ! set -q lucid_clean_indicator
	set -g lucid_clean_indicator (string replace -r -a '.' ' ' $lucid_dirty_indicator)
end

set -g lucid_cwd_color "$fish_color_normal"
set -g lucid_git_color "$fish_color_normal"
set -g lucid_git_dirty_color brblue
set -g lucid_git_separator_color "$fish_color_normal"
set -g lucid_prompt_symbol_color "$fish_color_normal"
set -g lucid_prompt_symbol_error_color red

# State used for memoization and async calls.
set -g __lucid_cmd_id 0
set -g __lucid_git_state_cmd_id -1
set -g __lucid_git_static ""
set -g __lucid_dirty ""

# Increment a counter each time a prompt is about to be displayed.
# Enables us to distingish between redraw requests and new prompts.
function __lucid_increment_cmd_id --on-event fish_prompt
	set __lucid_cmd_id (math $__lucid_cmd_id + 1)
end

# Abort an in-flight dirty check, if any.
function __lucid_abort_check
	if set -q __lucid_check_pid
		set -l pid $__lucid_check_pid
		functions -e __lucid_on_finish_$pid
		command kill $pid >/dev/null 2>&1
		set -e __lucid_check_pid
	end
end

function __lucid_git_status
	# Reset state if this call is *not* due to a redraw request
	set -l prev_dirty $__lucid_dirty
	if test $__lucid_cmd_id -ne $__lucid_git_state_cmd_id
		__lucid_abort_check

		set __lucid_git_state_cmd_id $__lucid_cmd_id
		set __lucid_git_static ""
		set __lucid_dirty ""
	end

	# Fetch git position & action synchronously.
	# Memoize results to avoid recomputation on subsequent redraws.
	if test -z $__lucid_git_static
		# Determine git working directory
		set -l git_dir (command git --no-optional-locks rev-parse --absolute-git-dir 2>/dev/null)
		if test $status -ne 0
			return 1
		end

		set -l position (command git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
		if test $status -ne 0
			# Denote detached HEAD state with short commit hash
			set position (command git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
			if test $status -eq 0
				set position "@$position"
			end
		end

		# TODO: add bisect
		set -l action ""
		if test -f "$git_dir/MERGE_HEAD"
			set action "merge"
		else if test -d "$git_dir/rebase-merge"
			set action "rebase"
		else if test -d "$git_dir/rebase-apply"
			set action "rebase"
		end

		set -l state $position
		if test -n $action
			set state "$state <$action>"
		end

		set -g __lucid_git_static $state
	end

	# Fetch dirty status asynchronously.
	if test -z $__lucid_dirty
		if ! set -q __lucid_check_pid
			# Compose shell command to run in background
			set -l check_cmd "git --no-optional-locks status -unormal --porcelain --ignore-submodules 2>/dev/null | head -n1 | count"
			set -l cmd "if test ($check_cmd) != "0"; exit 1; else; exit 0; end"

			begin
				set -g __lucid_check_pid 0
				command fish --private --command "$cmd" >/dev/null 2>&1 &
				set -l pid (jobs --last --pid)

				set -g __lucid_check_pid $pid

				# Use exit code to convey dirty status to parent process.
				function __lucid_on_finish_$pid --inherit-variable pid --on-process-exit $pid
					functions -e __lucid_on_finish_$pid

					if set -q __lucid_check_pid
						if test $pid -eq $__lucid_check_pid
							switch $argv[3]
							case 0
								set -g __lucid_dirty_state 0
								if status is-interactive
									commandline -f repaint
								end
							case 1
								set -g __lucid_dirty_state 1
								if status is-interactive
									commandline -f repaint
								end
							case '*'
								set -g __lucid_dirty_state 2
								if status is-interactive
									commandline -f repaint
								end
							end
						end
					end
				end
			end
		end

		if set -q __lucid_dirty_state
			switch $__lucid_dirty_state
			case 0
				set -g __lucid_dirty $lucid_clean_indicator
			case 1
				set -g __lucid_dirty $lucid_dirty_indicator
			case 2
				set -g __lucid_dirty "<err>"
			end

			set -e __lucid_check_pid
			set -e __lucid_dirty_state
		end
	end

	# Render git status. When in-progress, use previous state to reduce flicker.
	set_color $lucid_git_color
	echo -n $__lucid_git_static ''

	if ! test -z $__lucid_dirty
		set_color --dim $lucid_git_dirty_color
		echo -n $__lucid_dirty
		set_color normal
	else if ! test -z $prev_dirty
		set_color --dim $lucid_git_color
		echo -n $prev_dirty
		set_color normal
	end

	set_color normal
end

function __lucid_vi_indicator
	if [ $fish_key_bindings = "fish_vi_key_bindings" ]
		switch $fish_bind_mode
		case "insert"
			set_color normal
			echo -n "[I] "
		case "default"
			set_color purple
			echo -n "[N] "
		case "visual"
			set_color yellow
			echo -n "[V] "
		case "replace"
			set_color cyan
			echo -n "[R] "
		case "replace_one"
			set_color cyan
			echo -n "[O] "
		end
		set_color normal
	end
end

# Suppress default mode prompt
function fish_mode_prompt
end

function fish_prompt
	set -l last_pipestatus $pipestatus
	set -l cwd $(prompt_pwd)

	if test -z "$lucid_skip_newline"
		echo ''
	end

	set_color $lucid_cwd_color
	echo -sn $cwd
	set_color normal

	set -l bad_pipestatus '0'
	for status_code in $last_pipestatus
		if test "$status_code" -ne 0
			set bad_pipestatus $status_code
			break
		end
	end

	if test $cwd != '~'; or test -n "$lucid_git_status_in_home_directory"
		set -l git_state (__lucid_git_status)
		if test $status -eq 0
			echo -sn " @ $git_state"
		end
	end

	echo ''
	__lucid_vi_indicator

	set -l prompt_symbol "$lucid_prompt_symbol"
	set -l prompt_symbol_color "$lucid_prompt_symbol_color"

	if test "$bad_pipestatus" -ne 0
		set prompt_symbol "$lucid_prompt_symbol_error"
		set prompt_symbol_color "$lucid_prompt_symbol_error_color"
	end

	set_color "$prompt_symbol_color"
	echo -n "$prompt_symbol "
	set_color normal
end
