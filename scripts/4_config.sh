configure_zsh() { # make zsh default shell
  sudo -s 'echo /usr/local/bin/zsh >> /etc/shells' && chsh -s /usr/local/bin/zsh
  ln -s ../dotfiles/.zshrc ~
}

configure_git() {
  # remove old Apple pre-installed git
  sudo rm /usr/bin/git

  git config --global user.name "${git_name}"
  git config --global user.email "${github_email}"
  git config --global github.user "${github_username}"
  git config --global credential.helper osxkeychain
  git config --global core.editor "code --wait"
}

copy_app_icons() {
  cp icons/CoconutBattery.icns /Applications/Utilities/coconutBattery.app/Contents/Resources/AppIcon.icns
  touch /Applications/Utilities/coconutBattery.app

  cp icons/Handbrake.icns /Applications/Utilities/Handbrake.app/Contents/Resources/Handbrake.icns
  touch /Applications/Utilities/Handbrake.app

  cp icons/Transmission.icns /Applications/Utilities/Transmission.app/Contents/Resources/Transmission.icns
  touch /Applications/Utilities/Transmission.app

  cp icons/TuneInstructor.icns /Applications/Utilities/Tune•Instructor.app/Contents/Resources/AppIcon.icns
  touch /Applications/Utilities/Tune•Instructor.app

  cp icons/VLC.icns /Applications/Utilities/VLC.app/Contents/Resources/vlc.icns
  touch /Applications/Utilities/VLC.app

  sudo killall Finder && sudo killall Dock
}

configure_conda() {
  # to enable conda for the current user, add ENABLE_CONDA to bashrc or similar
  # the following grep checks if that line already exists before adding it
  ENABLE_CONDA=". /usr/local/miniconda3/etc/profile.d/conda.sh"
  FILE=~/.zprofile
  grep -qxF -- "$ENABLE_CONDA" "$FILE" || echo "$ENABLE_CONDA" >> "$FILE"
  ln -s "$(pwd)/dotfiles/conda_auto_env" /usr/local/bin
}

configure_ssh() {
  renew_sudo

  # Disable locale environment variable forwarding to remote machine.
  # This avoids 'bash: warning: setlocale: LC_CTYPE: cannot change locale' when ssh'ing into
  # server with different locale settings. See https://askubuntu.com/a/144448.
  # -i '': Edit file in place with no backup.
  sudo sed -i '' '/SendEnv LANG LC_\*/ s/^#*/#/' /etc/ssh/ssh_config

  ln -s ../dotfiles/ssh_config ~/.ssh/config
}