
install() {

  ask_details

  brew_install


  brew cleanup
}

# Run and log errors to file (but still show them when they happen).
readonly ERROR_LOG="${HOME}/Desktop/install_errors.log"
