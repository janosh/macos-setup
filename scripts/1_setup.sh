bold_echo() { # helper function for bold text
  echo "$(tput bold)${1}$(tput sgr0)"
}

renew_sudo() { # helper function used whenever the following command needs `sudo`
  sudo --stdin --validate <<< "${sudo_password}" 2> /dev/null
}

initial_setup() {
  export PATH="/usr/local/bin:${PATH}"

  trap 'exit 0' SIGINT # exit cleanly if aborted with ⌃C
  caffeinate & # prevent computer from going to sleep
}

ask_details() {
  # ask for the administrator password upfront, for commands that require `sudo`
  clear
  bold_echo 'Provide sudo password (will not be echoed).'
  until sudo --non-interactive true 2> /dev/null; do # if password is wrong, keep asking
    read -s -p 'Password: ' sudo_password
    echo
    sudo --stdin --validate <<< "${sudo_password}" 2> /dev/null
  done

  clear
  bold_echo 'Your Mac App Store details to install apps:'
  read -p 'Mac App Store email: ' mas_email
  read -s -p 'Mac App Store password (will not be echoed): ' mas_password

  clear
  bold_echo 'Git user info:'
  read -p 'First and last names: ' git_name
  read -p 'Github username: ' github_username
  read -p 'Github email: ' github_email

  clear
  bold_echo 'Some contact information to be set in the lock screen:'
  read -p 'Email address: ' email
  read -p 'Telephone number: ' telephone
  sudo --stdin defaults write /Library/Preferences/com.apple.loginwindow \
    LoginwindowText "This machine belongs to Janosh Riebesell. \
    If lost and found, contact ${email} or ${telephone}" \
    <<< "${sudo_password}" 2> /dev/null

  clear
}

update_system() {
  softwareupdate --install --all
}
