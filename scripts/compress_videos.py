from __future__ import annotations

import os
import subprocess
import sys

__author__ = "Janosh Riebesell"
__date__ = "2022-07-04"

DIRNAME = os.path.dirname(__file__)









def main(
    source_files: Sequence[str],
    write_file_map: bool = False,
    on_error: Literal["raise", "print", "ignore"] = "raise",
) -> int:

    in_out_map: dict[str, str] = {}


        try:
        except Exception as exc:
            if on_error == "raise":
                raise
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
        help="Output directory where compressed files will be created. New files will "
        "have the same basename as the original file.",
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
    args = parser.parse_args()

