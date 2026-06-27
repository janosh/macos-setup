"""Rank files in a git repo by net lines added."""

import argparse
import os
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
import webbrowser
from collections import Counter
from collections.abc import Sequence
from html import escape
from urllib.request import pathname2url

LineRankRow = tuple[int, int, int, str]
ParsedArgs = tuple[str, int, str, str, list[str]]
ANSI_GREEN = "\033[32m"
ANSI_RED = "\033[31m"
ANSI_BLUE = "\033[34m"
ANSI_YELLOW = "\033[33m"
ANSI_RESET = "\033[0m"
HTML_STYLE = """
body {
  color: #222;
  font-family: -apple-system, BlinkMacSystemFont, sans-serif;
  margin: 2rem;
}
table { border-collapse: collapse; width: 100%; }
th, td { border-bottom: 1px solid #ddd; padding: 0.35rem 0.5rem; text-align: left; }
th { position: sticky; top: 0; background: white; }
td.num, th.num { font-variant-numeric: tabular-nums; text-align: right; }
tr:hover { background: #f7f7f7; }
a { color: inherit; text-decoration-color: #999; text-underline-offset: 0.15rem; }
a:hover { text-decoration-color: currentColor; }
code { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
.added { color: #16a34a; }
.removed { color: #dc2626; }
.net-positive { color: #16a34a; }
.net-negative { color: #dc2626; }
.code-file { color: #2563eb; }
.test-file { color: #ca8a04; }
""".strip()


def parse_args(args: Sequence[str]) -> ParsedArgs:
    parser = argparse.ArgumentParser(
        allow_abbrev=False,
        description="Rank files in the current git repo by net lines added.",
        epilog=(
            "Examples:\n"
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("-n", "--limit", type=int, default=0)
    parser.add_argument("--sort", choices=["a", "r", "n"], default="n")
    for group, dest, options in [
        (
            parser.add_mutually_exclusive_group(),
            "source_name",
            [
                (("--local",), "local"),
                (("-s", "--staged"), "staged"),
                (("--staged-files",), "staged_files"),
                (("-u", "--unstaged"), "unstaged"),
                (("--history",), "history"),
            ],
        ),
        (
            parser.add_mutually_exclusive_group(),
            "format_name",
            [
                (("--table",), "table"),
                (("--md", "--markdown"), "markdown"),
                (("--html",), "html"),
            ],
        ),
    ]:
        for flags, const in options:
            group.add_argument(
                *flags,
                dest=dest,
                action="store_const",
                const=const,
            )
    parser.set_defaults(format_name="table", source_name=None)

    parsed_args, git_args = parser.parse_known_args(args)
    if parsed_args.limit < 0:
        parser.error("--limit expects a non-negative integer")
    return parsed_args.format_name, parsed_args.limit, parsed_args.sort, source_name, git_args


def command_path(command: str) -> str:
    """Return the absolute path to an executable on PATH."""
    abs_command_path = shutil.which(command)
    if abs_command_path is None:
        raise SystemExit(127)
    return abs_command_path


def git_stdout(
    git_args: Sequence[str],
    error_message: str,
    exit_code: int | None = None,
) -> str:
    """Run a git command and return stdout."""
    git_proc = subprocess.run(
        [command_path("git"), *git_args],
        check=False,
        capture_output=True,
        text=True,
    )
    if git_proc.returncode != 0:
        print(git_proc.stderr.strip() or error_message, file=sys.stderr)
        raise SystemExit(git_proc.returncode if exit_code is None else exit_code)
    return git_proc.stdout.strip()


def parse_numstat_rows(numstat_stdout: str, sort_name: str = "n") -> list[LineRankRow]:
    """Parse git numstat output into sorted line-rank rows."""
    added_by_file: Counter[str] = Counter()
    removed_by_file: Counter[str] = Counter()
            continue
        if not added_text.isdigit() or not removed_text.isdigit():
            continue
        added_by_file[file_path] += int(added_text)
        removed_by_file[file_path] += int(removed_text)

    return rows_from_counters(added_by_file, removed_by_file, sort_name)


def rows_from_counters(
    added_by_file: Counter[str],
    removed_by_file: Counter[str],
    sort_name: str = "n",
) -> list[LineRankRow]:
    """Return sorted line-rank rows from added and removed counters."""
        [
            (
                added_by_file[file_path] - removed_by_file[file_path],
                added_by_file[file_path],
                removed_by_file[file_path],
                file_path,
            )
            for file_path in added_by_file
        ],
    )


    history_args = list(git_args)
    pathspec_idx = history_args.index("--") if "--" in history_args else len(history_args)
    normalized_args: list[str] = []
    git_path = command_path("git")
    for arg in history_args[:pathspec_idx]:
        if arg.startswith(("-", "^")) or ".." in arg:
            normalized_args.append(arg)
            continue
            continue
        rev_check = subprocess.run(
            check=False,
            capture_output=True,
            text=True,
        )
        is_hex_sha = re.fullmatch(r"[0-9a-fA-F]{4,40}", arg) is not None
        normalized_args.append(f"{arg}^!" if rev_check.returncode == 0 and is_hex_sha else arg)
    return [*normalized_args, *history_args[pathspec_idx:]]


def collect_line_rank_rows(
    repo: str,
    source_name: str,
    git_args: Sequence[str],
    sort_name: str = "n",
) -> list[LineRankRow]:
    """Collect per-file line counts for the requested source."""
    if source_name == "history":
        return parse_numstat_rows(
            git_stdout(
            ),
            sort_name,
        )
    if source_name == "staged_files":
        staged_files = git_stdout(
            ["-C", repo, "diff", "--cached", "--name-only", "-z", *git_args],
        ).split("\0")[:-1]
        if not staged_files:
            return []
        return parse_numstat_rows(
            git_stdout(
                ["-C", repo, "diff", "--numstat", "HEAD", "--", *staged_files],
            ),
            sort_name,
        )
    diff_args = ["-C", repo, "diff", "--numstat"]
    if source_name == "local":
        diff_args.append("HEAD")
    elif source_name == "staged":
        diff_args.append("--cached")
    diff_args.extend(git_args)

    if source_name in {"local", "unstaged"}:
        if "--" in git_args:
            separator_idx = git_args.index("--")
            pathspec_args = ["--", *git_args[separator_idx + 1 :]]
        else:
            pathspec_only = git_args and all(not arg.startswith("-") for arg in git_args)
            pathspec_args = ["--", *git_args] if pathspec_only else []
        untracked_stdout = git_stdout(
            [
                "-C",
                repo,
                "ls-files",
                "--others",
                "--exclude-standard",
                "-z",
                *pathspec_args,
            ],
        )
        for file_path in filter(None, untracked_stdout.split("\0")):
            try:
                with open(f"{repo}/{file_path}", encoding="utf-8") as file:
                    added = sum(1 for _line in file)
            except (OSError, UnicodeDecodeError):
                continue
            if added:
                rows.append((added, added, 0, file_path))

    added_by_file: Counter[str] = Counter()
    removed_by_file: Counter[str] = Counter()
    for _, added, removed, file_path in rows:
        added_by_file[file_path] += added
        removed_by_file[file_path] += removed
    return rows_from_counters(added_by_file, removed_by_file, sort_name)


def line_expr(row: LineRankRow) -> str:
    """Return a compact added/removed/net expression."""
    net, added, removed, _ = row
    parts: list[str] = []
    if added:
        parts.append(f"{added:+d}")
    if removed:
        parts.append(f"-{removed}")
    if added and removed:
        parts.extend(["=", f"{net:+d}"])
    return " ".join(parts)


def total_row(rows: Sequence[LineRankRow]) -> LineRankRow:
    """Return a total row for displayed rows."""
    added = sum(row[1] for row in rows)
    removed = sum(row[2] for row in rows)


def print_table(rows: Sequence[LineRankRow]) -> None:
    """Print rows as an aligned shell table."""
    rows_with_total = [*rows, total_row(rows)]
    width = max(len("lines"), *(len(line_expr(row)) for row in rows_with_total))
    print(f"{'lines':>{width}}  file")
    for row in rows_with_total:
        net, added, removed, file_path = row
        line_parts: list[str] = []
        if added:
        if removed:
        if added and removed:
            net_text = f"{net:+d}"
            line_parts.extend(["=", net_text])
        line_text = " " * (width - len(line_expr(row))) + " ".join(line_parts)
        print(f"{line_text}  {file_text}")


def file_kind(file_path: str) -> str:
    """Return the display category for a file path."""
    file_name = os.path.basename(file_path)
    if (
        file_path.startswith("tests/")
        or file_name.startswith("test_")
        or ".test." in file_name
        or ".spec." in file_name
    ):
        return "test"


    """Run the git line rank CLI."""
    format_name, limit, sort_name, source_name, git_args = parse_args(
        sys.argv[1:] if args is None else args
    )
    repo = git_stdout(
        ["-C", os.getcwd(), "rev-parse", "--show-toplevel"],
        2,
    )
    rows = collect_line_rank_rows(repo, source_name, git_args, sort_name)
    if limit:
        rows = rows[:limit]

    if not rows:
        return 0

    if format_name == "table":
        print_table(rows)
    elif format_name == "markdown":
    else:
        repo_name = os.path.basename(repo)
        with tempfile.NamedTemporaryFile(
        ) as report_file:
            report_path = report_file.name
            report_file.write(
                f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Line Rank: {escape(repo_name)}</title>
<style>
{HTML_STYLE}
</style>
</head>
<body>
<h1>Line Rank: <code>{escape(repo_name)}</code></h1>
<p>Sorted by net lines added over git history. Source: <code>{escape(repo)}</code></p>
<thead>
<tr>
<th class="num">Lines</th><th>File</th>
</tr>
</thead>
<tbody>
{html_rows}
</tbody>
</table>
</body>
</html>
"""
            )
        report_url = "file://" + pathname2url(report_path)
        if not webbrowser.open(report_url) and sys.platform == "darwin":
            subprocess.run([command_path("open"), report_path], check=False)
        print(f"Opened {report_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
