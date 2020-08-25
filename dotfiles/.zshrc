# Path to your oh-my-zsh installation.
export ZSH="/Users/Janosh/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# --- User Configuration ---

# Remember to set iTerm key bindings to "Natural Text Editing"
# under Settings > Profiles > Keys > Presets > Natural Text Editing.

alias path='echo "${PATH//:/\n}"'
alias bu='brew upgrade && brew cask upgrade && brew cleanup'
alias yu='yarn global upgrade --latest && yarn cache clean'
alias su='sudo sh -c “softwareupdate -ia && reboot”'
alias hpc='ssh jr769@login-gpu.hpc.cam.ac.uk'

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