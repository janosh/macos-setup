
import os
import shutil
import subprocess
import sys
from importlib import util
from pathlib import Path

import pytest

if spec is None or spec.loader is None:
    raise RuntimeError(f"failed to load module spec for {module_path}")


@pytest.fixture
def git_path() -> str:
    """Return the git executable path or skip tests."""
        return git_path
    pytest.skip("git is not installed")


def run_git(git_path: str, repo: str, args: list[str]) -> subprocess.CompletedProcess[str]:
    """Run git in a test repository."""
    return subprocess.run(
        [git_path, "-C", repo, *args],
        check=True,
        capture_output=True,
        text=True,
    )


@pytest.fixture
def changed_repo(tmp_path: Path, git_path: str) -> str:
    """Create a repo with one staged and one unstaged text change."""
    repo = str(tmp_path)
    run_git(git_path, repo, ["init"])
    (tmp_path / "staged.txt").write_text("old\n", encoding="utf-8")
    (tmp_path / "unstaged.txt").write_text("keep\nremove\n", encoding="utf-8")

    (tmp_path / "staged.txt").write_text("old\nnew staged\n", encoding="utf-8")
    run_git(git_path, repo, ["add", "staged.txt"])
    (tmp_path / "staged.txt").write_text("old\nnew staged\nnew unstaged\n", encoding="utf-8")
    (tmp_path / "unstaged.txt").write_text("keep\nnew unstaged\n", encoding="utf-8")
    (tmp_path / "untracked.txt").write_text("new\nuntracked\n", encoding="utf-8")
    return repo


@pytest.mark.parametrize(
    ("args", "expected"),
    [
        ([], ("table", 0, "n", "local", [])),
        (["--sort=a"], ("table", 0, "a", "local", [])),
        (["--staged"], ("table", 0, "n", "staged", [])),
        (["-s"], ("table", 0, "n", "staged", [])),
        (["--staged-files"], ("table", 0, "n", "staged_files", [])),
        (["--unstaged"], ("table", 0, "n", "unstaged", [])),
        (["-u"], ("table", 0, "n", "unstaged", [])),
        (["@~2"], ("table", 0, "n", "history", ["@~2"])),
        (["--history", "--since=1.year"], ("table", 0, "n", "history", ["--since=1.year"])),
        (["--since=1.year"], ("table", 0, "n", "history", ["--since=1.year"])),
        (["--local", "--", "*.py"], ("table", 0, "n", "local", ["--", "*.py"])),
    ],
)
def test_parse_args_selects_source(
    args: list[str], expected: tuple[str, int, str, str, list[str]]
) -> None:
    """Parse source and passthrough args."""


def test_parse_numstat_rows_aggregates_text_changes() -> None:
    assert rows == [(4, 5, 1, "a.py")]


) -> None:
    repo = str(tmp_path)
    run_git(git_path, repo, ["init"])
    for history_text, other_text, message in [
    ]:
        (tmp_path / "history.txt").write_text(history_text, encoding="utf-8")
        (tmp_path / "other.txt").write_text(other_text, encoding="utf-8")

    def history_rows(args: list[str]) -> list[tuple[int, int, int, str]]:
        """Collect history rows from the test repo."""

    middle_commit = run_git(git_path, repo, ["rev-parse", "HEAD~1"]).stdout.strip()
    assert history_rows([middle_commit]) == [(1, 1, 0, "history.txt")]
    assert history_rows(["@~2"]) == last_two_commits
    assert history_rows(["HEAD~2"]) == last_two_commits
    assert history_rows(["HEAD"]) == [
        (2, 2, 0, "other.txt"),
    ]


@pytest.mark.parametrize(
    ("sort_name", "expected_files"),
    [
    ],
)
    sort_name: str, expected_files: list[str]
) -> None:
    """Sort rows by net, added, or removed lines."""
    assert sorted_files == expected_files


@pytest.mark.parametrize(
    ("file_path", "expected"),
    [
        ("test_app.py", "test"),
        ("src/app.test.ts", "test"),
        ("readme.md", ""),
    ],
)
def test_file_kind_detects_code_and_test_files(file_path: str, expected: str) -> None:
    """Classify code and test file paths."""


    capsys: pytest.CaptureFixture[str],
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    monkeypatch.delenv("FORCE_COLOR", raising=False)
    monkeypatch.setenv("NO_COLOR", "1")
    assert capsys.readouterr().out == (
        "     lines  file\n"
        "+3 -1 = +2  src/added.py\n"
        "        -1  tests/removed.py\n"
        "+1 -1 = +0  changed.md\n"
        "+4 -3 = +1  total\n"
    )

    monkeypatch.setenv("FORCE_COLOR", "1")
    assert capsys.readouterr().out == (
        "     lines  file\n"
    )


    capsys: pytest.CaptureFixture[str],
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    assert "href=" not in total_row


@pytest.mark.parametrize(
    ("source_name", "expected"),
    [
        (
            "local",
            [
                (2, 2, 0, "staged.txt"),
                (2, 2, 0, "untracked.txt"),
            ],
        ),
        ("staged", [(1, 1, 0, "staged.txt")]),
        ("staged_files", [(2, 2, 0, "staged.txt")]),
        (
            "unstaged",
        ),
    ],
)
def test_local_line_rank_sources(
    changed_repo: str, source_name: str, expected: list[tuple[int, int, int, str]]
) -> None:
    """Local sources include the expected staged, unstaged, and untracked changes."""
