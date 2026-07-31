# Deduplicate PATH: each entry below is prepended once per interactive shell.
typeset -U PATH path

autoload -U colors && colors
_git_prompt() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
  local ref dirty
  ref=$(git symbolic-ref --short HEAD 2>/dev/null) \
    || ref=$(git rev-parse --short HEAD 2>/dev/null) \
    || return
  [[ -n $(git status --porcelain --ignore-submodules=dirty 2>/dev/null) ]] && dirty=1
  print -n "%{$fg_bold[blue]%}git:(%{$fg[red]%}${ref//\%/%%}%{$fg[blue]%})"
  (( dirty )) && print -n " %{$fg[yellow]%}%1{✗%}"
  print -n "%{$reset_color%} "
}
PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%} \$(_git_prompt)"

zmodload -i zsh/complist
WORDCHARS=''
unsetopt menu_complete flowcontrol
setopt auto_menu complete_in_word always_to_end
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

if [[ -x ~/.venv/py314/bin/python ]]; then
  export VIRTUAL_ENV="$HOME/.venv/py314"
  export PATH="$VIRTUAL_ENV/bin:$PATH"
fi
# shellcheck disable=SC1091
[[ -f "$HOME"/.local/bin/env ]] && . "$HOME"/.local/bin/env

}
}
# Clean stale branches and non-origin remotes.
# shellcheck disable=SC2086
grcl() {
  local branch gone gh_merged prs remotes

  git fetch --prune

  gone=$(git branch -vv | awk '/: gone]/{print $1}')
  [ -n "$gone" ] && git branch -D $gone || echo "No gone branches to delete"

  for branch in $(git branch --format='%(refname:short)' | grep -vE '^(main|master)$'); do
    gh pr list --state merged --head "$branch" --json number -q '.[0]' 2>/dev/null | grep -q . && gh_merged="$gh_merged $branch"
  done
  [ -n "$gh_merged" ] && git branch -D $gh_merged || echo "No GitHub-merged branches to delete"

  prs=$(git branch --format='%(refname:short)' | grep '^pr/')
  [ -n "$prs" ] && git branch -D $prs || echo "No PR branches to delete"

  remotes=$(git remote | grep -vx origin)
  [ -n "$remotes" ] && for remote in $remotes; do git remote remove "$remote"; done || echo "No remotes to remove"
}
