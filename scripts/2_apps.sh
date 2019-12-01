#!/bin/zsh

brew_install() {
  renew_sudo
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
  brew bundle
}

yarn_install() { # Install JS CLIs.
  readonly local js_clis=(
    gatsby-cli \
    gatsby-dev-cli \
    netlify-cli \
    jest-cli \
    contentful-cli \
    eslint
  )

  for cli in "${js_clis[@]}"; do
    yarn global add $cli
  done
}