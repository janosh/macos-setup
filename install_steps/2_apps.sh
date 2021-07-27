#!/bin/sh

brew_install() {
  renew_sudo
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
  brew bundle
}

yarn_install() { # Install JS CLIs.
  yarn global add netlify-cli eslint prettier
}
