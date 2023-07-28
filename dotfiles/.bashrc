#!/bin/bash

set completion-ignore-case on

parse_git_branch() {
}
export PS1="\[\033[34m\]\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"



