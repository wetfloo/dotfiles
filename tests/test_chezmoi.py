"""Apply each platform's link definitions in a disposable home directory."""

import json
import os
from pathlib import Path
import subprocess
import tempfile


repo = Path(__file__).resolve().parents[1]
for platform in ("darwin", "linux", "windows"):
    with tempfile.TemporaryDirectory(prefix="dotfiles-chezmoi-") as directory:
        scratch = Path(directory)
        home = scratch / "home"
        home.mkdir()
        config = scratch / "chezmoi.toml"
        command = [
            "chezmoi", "--source", str(repo), "--destination", str(home),
            "--config", str(config), "--cache", str(scratch / "cache"),
            "--persistent-state", str(scratch / "state.boltdb"),
            "--override-data", json.dumps({"chezmoi": {"os": platform}}),
        ]

        def run(*arguments):
            return subprocess.run(
                command + list(arguments), check=True, capture_output=True, text=True
            ).stdout

        run("init", "--config-path", str(config))
        (home / ".config").mkdir(mode=0o700)
        (home / ".codex").mkdir()
        preserved = {
            ".gitconfig": "[user]\n\tname = Existing User\n",
            ".config/local-only": "unmanaged configuration\n",
            ".codex/auth.json": '{"unmanaged": true}\n',
        }
        for name, contents in preserved.items():
            (home / name).write_text(contents)
        (home / ".codex/auth.json").chmod(0o600)

        links = set(run("managed", "--include=symlinks").splitlines())
        nvim = "AppData/Local/nvim" if platform == "windows" else ".config/nvim"
        assert nvim in links
        assert (".config/nvim" in links) == (platform != "windows")
        assert ("AppData/Local/nvim" in links) == (platform == "windows")
        run("apply")
        run("verify")
        for name in links:
            target = Path(os.readlink(home / name))
            assert target.is_relative_to(repo) and target.exists(), (name, target)
        assert os.readlink(home / nvim) == str(repo / "config/nvim")
        run("apply")
        assert run("diff", "--no-pager") == ""
        for name, contents in preserved.items():
            assert (home / name).read_text() == contents
        assert (home / ".config").stat().st_mode & 0o777 == 0o700
        assert (home / ".codex/auth.json").stat().st_mode & 0o777 == 0o600
        print(f"{platform}: {len(links)} links verified; repeated apply preserves local files")
