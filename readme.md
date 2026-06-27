# macOS Setup Automation

## Purpose

Shell scripts and config to bootstrap a fresh macOS install (Homebrew, dotfiles, system defaults), plus Cursor agent rules/skills and assorted utilities.

## Usage


```sh
```



```sh
```

**New Mac Setup Note:**
When setting up new Macs with iCloud "Desktop & Documents" sync enabled, check [notes/to-self.md](notes/to-self.md) for steps to handle duplicate `Documents` folders.

## Organization

```text
.
├── agents/skills/             # agent skills symlinked into Cursor/Codex/Claude
├── notes/                     # personal runbooks (Mac setup, Cursor, etc.)
├── setup/                     # macOS bootstrap scripts
└── scripts/                   # one-off utilities
```

Setup scripts are prefixed with numbers and define functions only. `setup/main.sh` sources them and runs the install sequence.

