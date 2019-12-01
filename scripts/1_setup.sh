#!/bin/zsh

bold_echo() { # Helper function for bold text.
  echo "$(tput bold)${1}$(tput sgr0)"
}

renew_sudo() { # Helper function used whenever the ensuing command needs `sudo`.
  sudo --stdin --validate <<< "${sudo_password}" 2> /dev/null
}

ask_details() {
  # Ask for the administrator password upfront (to run commands that require `sudo`).
  bold_echo 'Provide sudo password (will not be echoed).'
  until sudo --non-interactive true 2> /dev/null; do # If password is wrong, keep asking.
    read -s 'sudo_password?Password: '
    echo
    renew_sudo
  done

  echo
  bold_echo 'Git user info:'
  read 'git_name?First and last names: '
  read 'github_username?Github username: '
  read 'github_email?Github email: '

  echo
  bold_echo 'Contact information to display on lock screen if device is lost:'
  echo 'Uses name and email from git user info above.'
  read 'phone?Phone number: '
  sudo --stdin defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText \
    "This machine belongs to ${git_name}. If lost and found, contact ${github_email} or ${phone}" \
    <<< "${sudo_password}" 2> /dev/null
}

update_system() {
  softwareupdate --install --all
}
