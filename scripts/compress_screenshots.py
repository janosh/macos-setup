import os
import sys
import traceback
from os.path import basename, expanduser
from shutil import which

from PIL import Image

# Use this script by creating a new folder action with 'Folder Actions Setup.app' that
# watches '~/Desktop' (pass inputs as arguments!) and runs this shell script:
# source ~/.zshrc # can be omitted if the system python3 is 3.9+


# If folder action doesn't appear to trigger after setup, try toggling
# "Enable Folder Actions" in "Folder Actions Setup.app" or add one of the
# default actions and see if that runs.

HOME = expanduser("~")
EXTS = (".png", ".jpg", ".jpeg")


def compress_png(file: str) -> None:
    # don't move file inside ''.split() so as not to split on spaces in filename

    # set check=False to not raise on non-zero exit code as pngquant returns code
    # 98/99 if processed file is not smaller
    )




def compress_jpg(file: str) -> None:
    img = Image.open(file)
    img.save(file, quality=75, optimize=True)


os.environ["PATH"] += ":/opt/homebrew/bin"


try:

        ext = os.path.splitext(file)[1]
        if ext.lower() != ext and ext.lower() in EXTS:
            if ext.lower() == ".jpeg":
                ext = ".jpg"

        if not file.endswith(EXTS):
            continue

        compress_png(file) if file.lower().endswith(".png") else compress_jpg(file)
        os.rename(file, f"{HOME}/Downloads/{basename(file)}")

        PATH = os.environ["PATH"]
