# Notes to self

## When having lost work in VS Code

Incident on 2022-08-04: I had a `functorch_ensemble.ipynb` notebook which I renamed to a regular Python script `.py` and continued editing for 2 hours. After saving all files, I noticed 1 remaining blue dot indicating an unsaved file. This happens often when using the interactive window so I thought nothing of it, closed the workspace and left for lunch. I later reopened the folder and saw the `functorch_ensemble.py` had the original JSON content from the Jupyter notebook in it. All my edits were missing.

Recovery: Following this [superuser answer](https://superuser.com/a/1723403), I was able to recover my changes from `~/Library/Application\ Support/Code/User/History` by grepping for the term `accuracy_dict` which I knew I had added late in the 2h editing process. So any matching file would be a more recent backup.

```sh
find . -name "*.py" -exec grep accuracy_dict {} +
```
