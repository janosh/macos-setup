install() {

  # source all shell scripts
  for shell_script in scripts/*.sh; do
    source "${shell_script}"
  done

  clear

  caffeinate & # prevent computer from going to sleep during setup
  ask_details
  sync_icloud
  update_system

  install_brew
  install_node

  install_brew_clis
  install_brew_casks
  install_mas_apps
  install_other_apps

  configure_zsh
  configure_git
  copy_app_icons
  configure_conda
  configure_ssh

  cleanup_brew
  cleanup_error_log
  move_manual_action_files
  killall caffeinate # allow computer to go back to sleep
  final_message
}

# run and log errors to file (but still show them when they happen)
readonly error_log="${HOME}/Desktop/install_errors.log"
install 2> >(tee "${error_log}")
