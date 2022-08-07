
## When having lost work in VS Code


Recovery: Following this [superuser answer](https://superuser.com/a/1723403), I was able to recover my changes from `~/Library/Application\ Support/Code/User/History` by grepping for the term `accuracy_dict` which I knew I had added late in the 2h editing process. So any matching file would be a more recent backup.

```sh
find . -name "*.py" -exec grep accuracy_dict {} +
```
