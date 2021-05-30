#!/bin/sh


bold_echo() { # Helper function for bold text.
  echo "$(tput bold)${1}$(tput sgr0)"
}

renew_sudo() { # Helper function used whenever the ensuing command needs `sudo`.
  sudo --stdin --validate <<< "${SUDO_PASSWORD}" 2> /dev/null
}

ask_details() {
  # Ask for the administrator password upfront (to run commands that require `sudo`).
  bold_echo 'Provide sudo password (will not be echoed).'
  until sudo --non-interactive true 2> /dev/null; do # If password is wrong, keep asking.
    read -r -s 'SUDO_PASSWORD?Password: '
    echo
    renew_sudo
  done

  echo
  bold_echo 'Git user info:'
  read -r 'GIT_NAME?First and last names: '
  read -r 'GITHUB_USERNAME?Github username: '
  read -r 'GITHUB_EMAIL?Github email: '

  echo
  bold_echo 'Contact information to display on lock screen if device is lost:'
  echo 'Uses name and email from git user info above.'
  read -r 'PHONE?Phone number: '
  sudo --stdin defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText \
    "This machine belongs to ${GIT_NAME}. If lost and found, contact ${GITHUB_EMAIL} or ${PHONE}" \
    <<< "${SUDO_PASSWORD}" 2> /dev/null
}

update_system() {
  softwareupdate --install --all
}
