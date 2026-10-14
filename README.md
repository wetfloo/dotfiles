# Dotfiles

Chezmoi manages the directory and file symlinks declared in `home/`.
Configuration contents stay in `config/`, `config_custom/`, and `config_windows/`.
New files inside a linked directory need no new link definitions.

## Setup

Install [chezmoi](https://www.chezmoi.io/install/), then initialize an existing
checkout from its root:

```sh
chezmoi init --source "$PWD"
chezmoi diff
chezmoi apply
chezmoi verify
```

The generated local config remembers this checkout. On another machine, after
committing and pushing the setup:

```sh
chezmoi init git@github.com:wetfloo/dotfiles.git
chezmoi diff
chezmoi apply
```

Use `--branch chezmoi` with `init` while this setup remains on that branch.
HTTPS cloning is also supported: `chezmoi init https://github.com/wetfloo/dotfiles.git`.

On Windows, enable [Developer Mode](https://www.chezmoi.io/user-guide/machines/windows/#create-symlinks)
before applying. Native paths are `~/AppData/Local/nvim`,
`~/AppData/Local/lazygit`, `~/AppData/Roaming/bat`,
`~/AppData/Roaming/yazi/config`, and `~/Documents/PowerShell`.
These mappings assume unredirected AppData and Documents folders.

On macOS, Lazygit's native `~/Library/Application Support/lazygit/config.yml`
also links to the shared config. The existing `.config/lazygit` link continues
to serve shells that set `XDG_CONFIG_HOME`. `.chezmoiignore` selects macOS-only
tools and Linux-only Zathura.

## Daily use

Edit the existing configuration directories or their deployed symlinks, then
commit normally. `chezmoi edit` edits a link definition, not its target contents.
Run `chezmoi apply` after changing link definitions. On other machines,
`chezmoi update` pulls and applies committed changes.

For a new app, add one `symlink_app.tmpl` under `home/private_dot_config/`:

```gotemplate
{{ joinPath .chezmoi.workingTree "config" "app" }}
```

Add any OS-specific destinations and select them in `home/.chezmoiignore`.
Chezmoi creates and maintains the links; no shell linking commands are needed.

Existing `~/.gitconfig` stays machine-specific. On a new machine, chezmoi creates
only the shared include; set your Git identity and signing key separately.
Shared Git settings enable signing. Applications and dependencies are installed
separately.

The legacy `scripts/dotfiles_relink` remains for rollback. Use `chezmoi apply`
instead; chezmoi does not run its Dock or NVRAM changes.

## Checks

```sh
python3 tests/test_chezmoi.py
```

The checks apply each OS's mappings in temporary home directories and verify
Neovim routing, link targets, repeated application, private permissions, and
preservation of unmanaged files. They do not run native Windows applications.
