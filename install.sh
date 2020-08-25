#!/bin/zsh

install() {
  # Source all install scripts.
  for script in install_steps/*.sh; do
    source "${script}"
  done

  caffeinate & # Prevent computer from going to sleep during setup.
  ask_details
  update_system

  brew_install
  yarn_install

  configure_zsh
  configure_git
  custom_app_icons
  configure_ssh

  brew cleanup
  cleanup_error_log
  killall caffeinate # Allow computer to go back to sleep.
  final_message
}

# Run and log errors to file (but still show them when they happen).
readonly error_log="${HOME}/Desktop/install_errors.log"
install 2> >(tee "${error_log}")
