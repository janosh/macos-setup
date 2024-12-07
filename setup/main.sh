
install() {

  ask_details

  brew_install

  configure_macos

  brew cleanup
}

# Run and log errors to file (but still show them when they happen).
readonly ERROR_LOG="${HOME}/Desktop/install_errors.log"
install 2>&1 | tee "${ERROR_LOG}"
