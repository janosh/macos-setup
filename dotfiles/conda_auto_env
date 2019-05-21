#!/bin/bash

# automatically activates conda environments when entering directories
# with a conda environment file which must be named one of
#   - env(ironment).y(a)ml
#   - requirements.y(a)ml
# if env doesn't exist yet, create it; deactivate env when exciting folder
# installation: copy chpwd() to .bashrc or save the whole script as
# file and source it in .bashrc, e.g. by placing it in /usr/local/bin
# or by symlinking conda_auto_env there

# chpwd is a zsh hook function that is executed whenever the current working
# directory is changed (http://zsh.sourceforge.net/Doc/Release/Functions.html).
chpwd() {
  FILE="$(find -E . -maxdepth 1 -regex '.*(env(ironment)?|requirements)\.ya?ml' -print -quit)"
  if [[ -e $FILE ]]; then
    ENV=$(sed -n 's/name: //p' $FILE)
    # check if env already active
    if [[ $CONDA_DEFAULT_ENV != $ENV ]]; then
      conda activate $ENV
      # if env activation unsuccessful, create new env from file
      if [ $? -ne 0 ]; then
        echo "Conda environment '$ENV' doesn't exist. Creating it now."
        conda env create -q
        conda activate $ENV
      fi
      CONDA_ENV_ROOT="$(pwd)"
    fi
  # deactivate env when exciting root dir
  elif [[ $PATH = */envs/* ]]\
    && [[ $(pwd) != $CONDA_ENV_ROOT ]]\
    && [[ $(pwd) != $CONDA_ENV_ROOT/* ]]
  then
    CONDA_ENV_ROOT=""
    conda deactivate
  fi
}

# execute chpwd on shell init
chpwd