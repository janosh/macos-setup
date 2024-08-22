
import os
import sys

_, dirname, prefix = sys.argv


os.chdir(dirname)

files = sorted(f for f in os.listdir() if not f.endswith(".xmp"))


print(f"Renaming {len(files)} files along with their XMP files in {dirname} with {prefix =}")


for idx, file in enumerate(files, start=1):
    basename, ext = os.path.splitext(file)
    os.rename(file, f"{prefix}{idx}{ext}")
    if os.path.exists(f"{basename}.xmp"):
        os.rename(f"{basename}.xmp", f"{prefix}{idx}.xmp")
