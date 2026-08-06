
import importlib.util
import os

import pytest

_SCRIPT = (
    f"{os.path.dirname(__file__)}/../agents/skills/"
    "address-local-coderabbit-comments/scripts/extract_comments.py"
)
_SPEC = importlib.util.spec_from_file_location("extract_comments", _SCRIPT)
assert _SPEC is not None
assert _SPEC.loader is not None
extract_comments = importlib.util.module_from_spec(_SPEC)
_SPEC.loader.exec_module(extract_comments)


@pytest.mark.parametrize(
    ("filename", "start_line", "end_line", "expected"),
    [
        ("a.py", 10, 10, "a.py:10"),
        ("a.py", 10, 12, "a.py:10-12"),
        ("a.py", 10, None, "a.py:10"),
        ("a.py", None, 12, "a.py:12"),
        ("a.py", None, None, "a.py"),
    ],
)
def test_format_location(
    filename: str, start_line: int | None, end_line: int | None, expected: str
) -> None:
    """Format file:line ranges compactly."""
    assert extract_comments.format_location(filename, start_line, end_line) == expected


def test_format_comments_text() -> None:
    text = extract_comments.format_comments_text(
        [
            {
                "filename": "src/lib/FindBar.svelte",
                "start_line": 64,
                "end_line": 70,
                "severity": "trivial",
                "comment": (
                    "Confirm the refresh effect tracks the query.\n\n"
                    "<details>\n<summary>Proposed change</summary>\n\n"
                    "```diff\n+ find.query\n```\n</details>"
                ),
            }
        ],
        review_title="Add find bar",
    )
    assert "src/lib/FindBar.svelte:64-70 [trivial]" in text
    assert "Confirm the refresh effect tracks the query." in text
    assert "<details>" not in text
    assert "find.query" not in text




    review = {
        "fileReviewMap": {"a.py": {"comments": [{"comment": "Fix the bug."}]}},
    }
    )

    )
