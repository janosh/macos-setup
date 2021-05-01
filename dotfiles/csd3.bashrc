# CSD3 bashrc
# https://docs.hpc.cam.ac.uk

alias sq="squeue -u jr769"
alias mb="mybalance"
alias brc="code ~/.bashrc"
alias path='tr ":" "\n" <<< "$PATH"'
source ~/.gitaliases

# Key bindings for up/down arrow search through history
# fro https://unix.stackexchange.com/a/20830
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

# https://coderwall.com/p/oqtj8w/the-single-most-useful-thing-in-bash
set show-all-if-ambiguous on
set completion-ignore-case on


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

# what to display as the prompt (PS1 = prompt string 1)
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}
# \[\033[32m\] = make what follows green
# \[\033[33m\] = make what follows yellow
# \[\033[34m\] = make what follows blue
# \[\033[00m\] = make what follows white
# #CONDA_DEFAULT_ENV adds conda environment to prompt
export PS1="\[\033[34m\]\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] ($CONDA_DEFAULT_ENV) $ "
