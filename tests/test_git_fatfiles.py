"""Check reports against Git's object sizes in a disposable repository."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest


script = Path(__file__).resolve().parents[1] / "scripts/git_fatfiles"


class GitFatfiles(unittest.TestCase):
    def setUp(self):
        self.scratch = tempfile.TemporaryDirectory(prefix="dotfiles-fatfiles-")
        self.addCleanup(self.scratch.cleanup)
        self.repo = Path(self.scratch.name)
        self.env = dict(os.environ, GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM="1",
                        GIT_AUTHOR_NAME="Test", GIT_AUTHOR_EMAIL="test@example.com",
                        GIT_COMMITTER_NAME="Test", GIT_COMMITTER_EMAIL="test@example.com")
        self.git("init", "--quiet", "--template=")
        (self.repo / "src").mkdir()
        self.files = {
            "root.txt": "root contents\n",
            "src/change.txt": "first version\n",
            "src/deleted.txt": "deleted contents\n",
            " leading and trailing ": "whitespace path\n",
            "tab\tand\\backslash": "unusual path\n",
            "large": "".join(f"{number:08x}" for number in range(4096)),
        }
        for name, contents in self.files.items():
            (self.repo / name).write_text(contents)
        (self.repo / "broken-link").symlink_to("missing-target")
        self.git("add", ".")
        self.git("commit", "--quiet", "-m", "first")
        (self.repo / "src/change.txt").write_text("second version\n")
        (self.repo / "src/deleted.txt").unlink()
        self.git("add", ".")
        self.git("commit", "--quiet", "-m", "second")

    def git(self, *args):
        return subprocess.run(["git", *args], cwd=self.repo, env=self.env,
                              capture_output=True, text=True, check=True).stdout.strip()

    def run_script(self, *args, cwd=None, check=True):
        return subprocess.run([str(script), *args], cwd=cwd or self.repo, env=self.env,
                              capture_output=True, text=True, check=check)

    def report(self, *args, cwd=None):
        result = self.run_script("--nounits", *args, cwd=cwd)
        self.assertEqual(result.stderr, "")
        records = [line.partition("\t") for line in result.stdout.splitlines()]
        sizes = [int(size) for size, _, _ in records]
        self.assertEqual(sizes, sorted(sizes))
        return {path: int(size) for size, _, path in records}

    def object_size(self, revision, path):
        object_id = self.git("rev-parse", f"{revision}:{path}")
        result = subprocess.run(
            ["git", "cat-file", "--batch-check=%(objectsize:disk)"], input=object_id + "\n",
            cwd=self.repo, env=self.env, capture_output=True, text=True, check=True,
        )
        return int(result.stdout)

    def expected(self, maximum=False):
        paths = [*self.files, "broken-link"]
        sizes = {path: self.object_size("HEAD~", path) for path in paths}
        latest = self.object_size("HEAD", "src/change.txt")
        sizes["src/change.txt"] = (max(sizes["src/change.txt"], latest) if maximum
                                   else sizes["src/change.txt"] + latest)
        return sizes

    def test_sums_maxima_and_paths_for_loose_and_packed_objects(self):
        for packed in (False, True):
            with self.subTest(packed=packed):
                if packed:
                    self.git("repack", "-ad")
                self.assertEqual(self.report(), self.expected())
                self.assertEqual(self.report("--nosum"), self.expected(maximum=True))
                self.assertEqual(self.report(cwd=self.repo / "src"), self.expected())

    def test_deleted_filters_include_broken_symlinks(self):
        expected = self.expected()
        deleted = {"src/deleted.txt": expected.pop("src/deleted.txt")}
        self.assertEqual(self.report("--deleted"), deleted)
        self.assertEqual(self.report("--nodeleted"), expected)

    def test_directories_group_root_files_and_filter_before_grouping(self):
        expected = self.expected()
        root_size = sum(size for path, size in expected.items() if "/" not in path)
        src_size = sum(size for path, size in expected.items() if path.startswith("src/"))
        self.assertEqual(self.report("--directories"), {".": root_size, "src": src_size})
        self.assertEqual(self.report("--directories", "--deleted"),
                         {"src": expected["src/deleted.txt"]})
        maxima = self.expected(maximum=True)
        self.assertEqual(self.report("--directories", "--nosum"),
                         {".": max(size for path, size in maxima.items() if "/" not in path),
                          "src": max(size for path, size in maxima.items() if path.startswith("src/"))})

    def test_units_and_short_options(self):
        result = self.run_script("-s", "-u")
        self.assertEqual(result.stderr, "")
        self.assertRegex(result.stdout, r"\d+ B\troot.txt\n")
        self.assertRegex(result.stdout, r"\d+\.\d KiB\tlarge\n")
        self.assertEqual(len(result.stdout.splitlines()), len(self.expected()))

    def test_help_and_failures_outside_repository(self):
        outside = self.repo / "outside"
        outside.mkdir()
        # The parent repository is deliberately hidden from Git here.
        self.env["GIT_CEILING_DIRECTORIES"] = str(self.repo)
        self.assertEqual(self.run_script("--help", cwd=outside, check=False).returncode, 0)
        self.assertNotEqual(self.run_script(cwd=outside, check=False).returncode, 0)
        self.assertNotEqual(self.run_script("--unknown", check=False).returncode, 0)

    def test_empty_repository(self):
        empty = self.repo / "empty"
        empty.mkdir()
        subprocess.run(["git", "init", "--quiet", "--template=", str(empty)],
                       env=self.env, check=True, capture_output=True)
        self.assertEqual(self.run_script(cwd=empty).stdout, "")


if __name__ == "__main__":
    unittest.main()
