# dotfiles

Chezmoi manages the directory and file symlinks declared in [`chezmoi_template/`](chezmoi_template/).
Configuration contents stay in [`config/`](config/).
[`config_custom/`](config_custom/) is meant for other configuration
that isn't meant to be linked directly.

## Setup

Install [`chezmoi`](https://www.chezmoi.io/install/),
then initialize an existing checkout from its root:

```sh
chezmoi init --source "$PWD"
chezmoi diff
chezmoi apply
chezmoi verify
```

On another machine, after committing and pushing the setup:

```sh
chezmoi init git@github.com:wetfloo/dotfiles.git
chezmoi diff
chezmoi apply
```

On Windows, before applying,
enable [Developer Mode](https://www.chezmoi.io/user-guide/machines/windows/#create-symlinks)
Native paths such as `~/AppData/Local/nvim` require it.

## Usage

Edit the existing configuration directories
or their deployed symlinks, then commit normally.
Run `chezmoi apply` after changing link definitions. On other machines,
`chezmoi update` pulls and applies committed changes.

### Example

For a new app, to link `app` file into `~/.config/`,
add a `symlink_app.tmpl` file under [`chezmoi_template/private_dot_config/`](chezmoi_template/)
with the following contents:

```gotemplate
{{ joinPath .chezmoi.workingTree "config" "app" }}
```

If needed, add any OS-specific destinations and select them in [`.chezmoiignore`](chezmoi_template/.chezmoiignore).

Legacy [`scripts/dotfiles_relink`](scripts/dotfiles_relink) remains for rollback.
Use `chezmoi apply` instead; chezmoi does not run its macOS Dock or NVRAM changes.

## Checks

```sh
python3 tests/test_chezmoi.py
python3 tests/test_tmux_scripts.py
python3 tests/test_git_fatfiles.py
```

The checks apply each OS's mappings in temporary home directories and verify
Neovim routing, link targets, repeated application, private permissions, and
preservation of unmanaged files. They do not run native Windows applications.

The script checks use isolated command stubs and disposable Git repositories.
They leave running tmux sessions and existing repositories alone.
