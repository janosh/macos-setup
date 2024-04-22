from __future__ import annotations

import os
import subprocess
import sys

if TYPE_CHECKING:
    from collections.abc import Sequence

__author__ = "Janosh Riebesell"
__date__ = "2022-07-04"

DIRNAME = os.path.dirname(__file__)










def main(
    source_files: Sequence[str],
    outdir: str | None = None,
    suffix: str | None = None,
    write_file_map: bool = False,
    on_error: Literal["raise", "print", "ignore"] = "raise",
) -> int:
        raise ValueError("No input files received")
        raise ValueError("Either outdir or suffix must be provided")

    if outdir:
        if os.path.isfile(outdir):
            raise ValueError(
                f"{outdir=} must be a (possibly non-existent) directory, not a file"
            )
        os.makedirs(outdir, exist_ok=True)

    in_out_map: dict[str, str] = {}


        try:
        except Exception as exc:
            if on_error == "raise":
                raise
            if on_error == "print":
        in_out_map[file_path] = out_path

    if write_file_map:
        with open(file_map_path, "w") as json_file:
        print(f"A map from input to output file paths was written to {file_map_path}")



if __name__ == "__main__":
    import argparse

    try:
        with open(f"{DIRNAME}/compress-videos.md") as md_file:
            description = md_file.read()
    except FileNotFoundError:
        description = ""

    parser = argparse.ArgumentParser(description=description)
    parser.add_argument("source_files", nargs="+", help="Video files to be compressed")

    out_group = parser.add_mutually_exclusive_group()
    out_group.add_argument(
        *("-o", "--outdir"),
        help="Output directory where compressed files will be created. New files will "
        "have the same basename as the original file.",
    )
    out_group.add_argument(
        *("-s", "--suffix"),
        help="Suffix to append to the original filename to create the output filename. "
    )
    parser.add_argument(
        "--write-file-map",
        action="store_true",
        help="Write JSON file mapping input to output file paths to outdir.",
    )
    parser.add_argument(
        "--on-error",
        choices=("raise", "print", "ignore"),
        default="raise",
        help="What to do if an error occurs. If 'raise', will exit non-zero. If "
        "'print' will print error to stderr, then continue with next file. If "
        "'ignore' directly continues with next file.",
    )
    parser.add_argument(
        *("-q", "--quality"),
        type=int,
    )
    args = parser.parse_args()

