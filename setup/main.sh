#!/usr/bin/env zsh


# %x is this script's own path, which is empty when the body arrived over a pipe rather
# than as a file. PWD covers being run from the repo root or from inside setup/.
setup_dir=
for dir in "${${(%):-%x}:A:h}" "${PWD}/setup" "${PWD}"; do
  [[ -f "${dir}/1-setup.sh" ]] && setup_dir=${dir} && break
done

  if [[ -n ${setup_dir} ]]; then
  fi
}

install() {

  ask_details

  brew_install

  configure_macos

  brew cleanup
}

# Run and log errors to file (but still show them when they happen).
readonly ERROR_LOG="${HOME}/Desktop/install_errors.log"
install 2>&1 | tee "${ERROR_LOG}"
