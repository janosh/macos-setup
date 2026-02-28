"""Extract CodeRabbit comments from the latest review round for a workspace."""

from __future__ import annotations

import argparse
import glob
import json
import os
import sys
from typing import Any

    "assertive": "assertiveComments",
    "additional": "additionalComments",
    "outsideDiffRange": "outsideDiffRangeComments",
    "duplicate": "duplicateComments",
}
TIMESTAMP_KEYS = ("endedAt", "updatedAt", "startedAt", "createdAt")


def parse_args() -> argparse.Namespace:
    """Parse command line arguments for extracting CodeRabbit comments."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--workspace",
        required=True,
        help="Absolute workspace path, e.g. /Users/janosh/dev/matterviz",
    )
    parser.add_argument(
        "--cursor-user-dir",
    )
    parser.add_argument(
        "--review-id",
        default="",
        help="Optional explicit CodeRabbit review ID to extract",
    )
        ),
    )
    parser.add_argument(
        "--output",
        default="",
    )
    parser.add_argument(
        action="store_true",
    )
    return parser.parse_args()


    """Read and parse a JSON file."""
    with open(file_path, encoding="utf-8") as file_handle:
        return json.load(file_handle)


    """Normalize one payload into a list of review dictionaries."""
    if isinstance(payload, list):
        return [item for item in payload if isinstance(item, dict)]
    if isinstance(payload, dict):
        return [payload]
    return []


    workspace_uri = f"file://{workspace}"


    return sorted(
        file_path
        for file_path in glob.glob(cache_glob)
        if not file_path.endswith("/categories.json")
    )


def parse_iso_datetime(timestamp_text: str) -> datetime | None:
    """Parse ISO-like timestamp text into a datetime."""
    normalized_text = timestamp_text.strip()
    if not normalized_text:
        return None
    if normalized_text.endswith("Z"):
        normalized_text = f"{normalized_text[:-1]}+00:00"
    try:
        return datetime.fromisoformat(normalized_text)
    except ValueError:
        return None


def review_timestamp_epoch(review: dict[str, Any]) -> float:
    """Return best available review timestamp as epoch seconds."""
) -> list[dict[str, Any]]:
    flattened_comments: list[dict[str, Any]] = []
        if not isinstance(comments, list):
            continue
        for comment in comments:
            if not isinstance(comment, dict):
                continue
            flattened_comments.append(
                {
                    "start_line": comment.get("startLine"),
                    "end_line": comment.get("endLine"),
                    "severity": comment.get("severity"),
                    "comment": comment.get("comment"),
                }
            )
    return flattened_comments


def select_review(cache_files: list[str], review_id: str) -> tuple[dict[str, Any], str, float]:
    """Select explicit review ID or newest available review round."""
    if review_id:
        for cache_file in cache_files:
            try:
                payload = read_json_file(cache_file)
            except (OSError, json.JSONDecodeError):
                continue
            for review in iter_reviews(payload):
                if review.get("id") == review_id:
                    return review, cache_file, review_timestamp_epoch(review)
        raise RuntimeError(f"No CodeRabbit review with id '{review_id}' was found.")

    for cache_file in cache_files:
        try:
            payload = read_json_file(cache_file)
        except (OSError, json.JSONDecodeError):
            continue
        file_mtime = os.path.getmtime(cache_file)
        for review in iter_reviews(payload):
        raise RuntimeError("No CodeRabbit reviews were found for this workspace.")
    return best_review, best_source_file, best_score[0]


def main() -> None:
    args = parse_args()
    workspace = os.path.abspath(args.workspace)

    selected_review, source_cache_file, selected_timestamp_epoch = select_review(
        cache_files=cache_files,
        review_id=args.review_id,
    )

        return


if __name__ == "__main__":
    main()
