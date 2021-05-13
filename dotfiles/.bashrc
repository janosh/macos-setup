# CSD3 bashrc
# https://docs.hpc.cam.ac.uk

alias sq="squeue -u jr769"
alias mb="mybalance"
alias brc="code ~/.bashrc"
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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jr769/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jr769/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jr769/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jr769/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

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
