#!/bin/sh

install() {
  # Source all install scripts.
  source install_steps/1_setup.sh
  source install_steps/2_apps.sh
  source install_steps/3_config.sh
  source install_steps/4_cleanup.sh

  caffeinate & # Prevent computer from going to sleep during setup.
  ask_details
  update_system

  brew_install
  yarn_install

  configure_zsh
  configure_git
  symlink_custom_scripts
  configure_ssh

  brew cleanup
  cleanup_error_log
  killall caffeinate # Allow computer to go back to sleep.
  final_message
}

# Run and log errors to file (but still show them when they happen).
readonly ERROR_LOG="${HOME}/Desktop/install_errors.log"
install 2> >(tee "${ERROR_LOG}")
