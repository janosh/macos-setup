# CSD3 bashrc
# https://docs.hpc.cam.ac.uk

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

alias sq="squeue -u jr769"
alias mb="mybalance"
alias path='tr ":" "\n" <<< "$PATH"'
source ~/.gitaliases

# if no command specified and shell input is name of a directory, assume cd
# https://gnu.org/software/bash/manual/html_node/The-Shopt-Builtin
shopt -s autocd

if [ -z "$PS1" ] # check if shell is interactive (https://superuser.com/a/686293)
# if so, do interactive initialization (bind unavailable in non-interactive)
then
    # Key bindings for up/down arrow search through history
    # from https://unix.stackexchange.com/a/20830
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
    bind '"\eOA": history-search-backward'
    bind '"\eOB": history-search-forward'
fi

# https://coderwall.com/p/oqtj8w/the-single-most-useful-thing-in-bash
# set show-all-if-ambiguous on
# set completion-ignore-case on

conda activate py38

# shell prompt (PS1 = prompt string 1)
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}
# color codes affect the text following them
# \[\033[32m\] = green
# \[\033[33m\] = yellow
# \[\033[34m\] = blue
# \[\033[00m\] = white
export PS1="\[\033[34m\]\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "

export FW_CONFIG_FILE=/home/jr769/atomate/config/FW_config.yaml
