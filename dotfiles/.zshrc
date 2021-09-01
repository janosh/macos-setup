# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
export ZSH_THEME="robbyrussell"

# shellcheck disable=SC1090
source ~/.oh-my-zsh/oh-my-zsh.sh

# --- User Configuration ---

# Remember to set iTerm key bindings to "Natural Text Editing"
# under Settings > Profiles > Keys > Presets > Natural Text Editing.

# activate default virtualenv
# shellcheck disable=SC1090
source ~/.venv/py39/bin/activate


alias ga='git add'
alias gc='git commit'
alias gl='git pull'
alias gf='git fetch'
alias gr='git remote'
alias grv='git remote -v'
alias gp='git push'
alias gb='git branch'
alias gsw='git switch'
alias gco='git checkout'
alias grb='git rebase'
alias glog='git log --oneline'

alias path='echo "${PATH//:/\n}"'
alias brewup='brew upgrade && brew cleanup'
alias yarnup='yarn global upgrade --latest && yarn cache clean'
alias ssh="ssh -F ~/.ssh/config"  # https://stackoverflow.com/a/63935109


# Source brew-installed zsh plugins.
# shellcheck disable=SC1094,SC1091
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# shellcheck disable=SC1091
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
# shellcheck disable=SC1094,SC1091
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://github.com/zsh-users/zsh-autosuggestions/issues/351
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)
