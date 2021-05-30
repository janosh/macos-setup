# Path to your oh-my-zsh installation.
export ZSH="/Users/Janosh/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
export ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

# --- User Configuration ---

# Remember to set iTerm key bindings to "Natural Text Editing"
# under Settings > Profiles > Keys > Presets > Natural Text Editing.

alias ga='gid add'
alias gc='gid commit'
alias gl='git pull'
alias gf='git fetch'
alias gr='git remote'
alias grv='git remote-v'
alias gp='git push'
alias gb='git branch'
alias gsw='git switch'
alias grb='git rebase'
alias glog='git log -g'

alias path='echo "${PATH//:/\n}"'
alias brewup='brew upgrade && brew cleanup'
alias yarnup='yarn global upgrade --latest && yarn cache clean'
alias ssh="ssh -F ~/.ssh/config"  # https://stackoverflow.com/a/63935109

# Makes conda activate <env_name> available in terminal.
source "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
conda activate py38

# Source brew-installed zsh plugins.
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath=(/usr/local/share/zsh-completions $fpath)

# https://github.com/zsh-users/zsh-autosuggestions/issues/351
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)

function gam() { ~/Repos/google-workspace/gam/gam "$@" ; }
