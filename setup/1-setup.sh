#!/usr/bin/env zsh
# zsh, not bash: ask_details uses zsh's `read VAR'?prompt'` form below

  sudo --stdin --validate <<< "${SUDO_PASSWORD}" 2> /dev/null
}

ask_details() {
  # Prompt for sudo unless SUDO_PASSWORD is already set.
  if [ -z "$SUDO_PASSWORD" ]; then
    # Ask for the administrator password upfront (to run commands that require `sudo`).
    until sudo --non-interactive true 2> /dev/null; do # If password is wrong, keep asking.
      read -r -s SUDO_PASSWORD'?Password: '
      echo
      renew_sudo
    done
  fi

  # Only set LoginwindowText if read exits non-zero (meaning not set yet).
  if ! defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText &> /dev/null; then
    echo
    read -r FULLNAME'?Full name: '
    read -r EMAIL'?Email: '
    read -r PHONE'?Phone number: '

    sudo --stdin defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText \
      "This machine belongs to ${FULLNAME}. If lost and found, contact ${EMAIL} or ${PHONE}." \
      <<< "${SUDO_PASSWORD}" 2> /dev/null
  fi
}
