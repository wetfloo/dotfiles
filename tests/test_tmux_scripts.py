"""Exercise session commands without touching the user's tmux server."""

import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


scripts = Path(__file__).resolve().parents[1] / "scripts"


class TmuxScripts(unittest.TestCase):
    def setUp(self):
        self.scratch = tempfile.TemporaryDirectory(prefix="dotfiles-tmux-")
        self.addCleanup(self.scratch.cleanup)
        self.home = Path(self.scratch.name)
        self.bin = self.home / "bin"
        self.bin.mkdir()
        self.log = self.home / "calls.jsonl"
        self.env = dict(os.environ, HOME=str(self.home), TMUX="",
                        PATH=f"{self.bin}:{scripts}:/usr/bin:/bin",
                        CALL_LOG=str(self.log))
        self.stub("tmux", """
import json, os, sys
args = sys.argv[1:]
with open(os.environ['CALL_LOG'], 'a') as log:
    log.write(json.dumps(args) + '\\n')
if args[0] in ('ls', 'list-sessions'):
    print(os.environ.get('SESSIONS', ''), end='')
    sys.exit(int(os.environ.get('LIST_STATUS', '0')))
if args[0] == 'has-session':
    sys.exit(0 if os.environ.get('EXISTS') else 1)
if args[0] == 'new-session':
    if os.environ.get('CREATE_FAIL'):
        sys.exit(1)
    if '-P' in args:
        print('0')
if args[0] == 'new-window':
    print('@7')
""")

    def stub(self, name, body):
        command = self.bin / name
        command.write_text(f"#!{os.sys.executable}\n{body}")
        command.chmod(0o755)

    def run_script(self, name, *args, check=True, **environment):
        return subprocess.run(
            ["/bin/bash", str(scripts / name), *map(str, args)],
            env=dict(self.env, **environment), cwd=self.home,
            capture_output=True, text=True, check=check,
        )

    def calls(self):
        return [json.loads(line) for line in self.log.read_text().splitlines()]

    def test_join_quotes_paths_and_matches_exactly(self):
        project = self.home / "my project.v2:work"
        project.mkdir()
        self.run_script("tmux_join", project)
        calls = self.calls()
        target = "=my project_v2_work"
        self.assertEqual(calls[0], ["has-session", "-t", target])
        self.assertEqual(calls[-1], ["attach-session", "-t", target])
        windows = [call for call in calls if call[0] == "new-window"]
        self.assertEqual(len(windows), 2)
        for call in [calls[1], *windows]:
            self.assertEqual(call[call.index("-c") + 1], str(project))
        self.assertTrue(all("-P" in call for call in windows))
        self.assertEqual([call[-2:] for call in calls if call[0] == "send-keys"],
                         [["nvim .", "Enter"], ["lazygit", "Enter"]])

    def test_join_home_and_existing_session(self):
        self.run_script("tmux_join", "/")
        self.assertEqual(len(self.calls()), 3)
        self.assertIn(str(self.home), self.calls()[1])
        self.log.unlink()
        self.run_script("tmux_join", "/", EXISTS="1", TMUX="server,1,0")
        self.assertEqual(self.calls()[-1], ["switch-client", "-t", "=/"])
        self.assertEqual(len(self.calls()), 2)

    def test_join_reports_bad_input_and_creation_failure(self):
        self.assertNotEqual(self.run_script("tmux_join", check=False).returncode, 0)
        self.assertNotEqual(self.run_script("tmux_join", "missing", check=False).returncode, 0)
        self.assertNotEqual(self.run_script("tmux_join", "/", CREATE_FAIL="1", check=False).returncode, 0)
        self.assertFalse(any(call[0] == "attach-session" for call in self.calls()))

    def test_sessionizer_passes_a_single_path(self):
        self.stub("tmux_join", """
import json, os, sys
with open(os.environ['CALL_LOG'], 'w') as log:
    log.write(json.dumps(sys.argv[1:]) + '\\n')
""")
        self.run_script("tmux_sessionizer", self.home / "project with spaces")
        self.assertEqual(self.calls(), [[str(self.home / "project with spaces")]])

    def test_sessionizer_discovers_projects_and_handles_cancel(self):
        project = self.home / "Documents/Projects/project with spaces"
        project.mkdir(parents=True)
        self.stub("fzf", """
import os, sys
paths = sys.stdin.buffer.read().split(b'\\0')
expected = os.path.join(os.environ['HOME'], 'Documents/Projects/project with spaces/')
assert os.fsencode(expected) in paths, paths
if os.environ.get('CANCEL'):
    sys.exit(int(os.environ['CANCEL']))
print(expected)
""")
        self.run_script("tmux_sessionizer", EXISTS="1")
        self.assertEqual(self.calls()[-1], ["attach-session", "-t", "=project with spaces"])
        self.log.unlink()
        self.run_script("tmux_sessionizer", CANCEL="130")
        self.assertFalse(self.log.exists())
        self.assertEqual(self.run_script("tmux_sessionizer", CANCEL="2", check=False).returncode, 2)

    def test_avoid_session_starts_without_server_or_numbered_sessions(self):
        for sessions, status in (("", "1"), ("work\n", "0")):
            with self.subTest(sessions=sessions):
                self.run_script("tmux_avoid_session", SESSIONS=sessions, LIST_STATUS=status)
                self.assertIn("tmux_sessionizer0", self.calls()[-1])

    def test_avoid_session_increments_only_numbered_sessions(self):
        self.run_script("tmux_avoid_session", TMUX="server,1,0",
                        SESSIONS="tmux_sessionizer2\ntmux_sessionizer09\ntmux_sessionizer100x\nwork\n")
        self.assertIn("tmux_sessionizer10", self.calls()[-2])
        self.assertEqual(self.calls()[-1], ["switch-client", "-t", "=tmux_sessionizer10"])

    def test_dotfiles_avoid_skips_all_selector_sessions(self):
        self.run_script("dotfiles_tmux_avoid", SESSIONS="dotfiles\ntmux_sessionizer\ntmux_sessionizer3\nwork space\n")
        self.assertEqual(self.calls()[-1], ["attach-session", "-t", "=work space"])

    def test_dotfiles_avoid_creates_a_session_when_none_qualify(self):
        self.run_script("dotfiles_tmux_avoid", LIST_STATUS="1", TMUX="server,1,0")
        self.assertEqual(self.calls()[-1], ["switch-client", "-t", "=0"])
        self.assertEqual(self.calls()[-2][0], "new-session")


if __name__ == "__main__":
    unittest.main()
