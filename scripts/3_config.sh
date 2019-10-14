configure_zsh() {
  # Make zsh the default shell.
  sudo -s 'echo /usr/local/bin/zsh >> /etc/shells' && chsh -s /usr/local/bin/zsh
  ln -s ../dotfiles/.zshrc ~
}

configure_git() {
  # Remove outdated Apple-pre-installed git (thereby
  # using the current brew-installed git instead).
  sudo rm /usr/bin/git

  # Configure git username.
  git config --global user.name "${git_name}"
  # Authenticate with GitHub.
  git config --global user.email "${github_email}"
  git config --global github.user "${github_username}"
  git config --global credential.helper osxkeychain

  # Use VSCode as git editor (e.g. for interactive rebase sessions).
  git config --global core.editor "code --wait"
  # Automatically create temporary stash entry before rebase begins, and reapply afterwards.
  # https://git-scm.com/docs/git-config#Documentation/git-config.txt-rebaseautoStash
  git config --global rebase.autoStash true
  # Automatically move fixup commits to the correct line during interactive rebase.
  git config --global rebase.autoSquash true

  # Run `flake8 --install-hook git` to add flake8 pre-commit
  # hook to a project (will be added to .git/hooks/pre-commit).
  # https://flake8.pycqa.org/en/latest/user/using-hooks.html
  # The line below aborts commits with linter issues.
  git config --bool flake8.strict true

  # Configure global hooks directory.
  # https://stackoverflow.com/a/37293198
  git config --global core.hooksPath $(pwd)/dotfiles/gitHooks
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
  # To enable conda for the current user, add ENABLE_CONDA to bashrc or similar.
  # The following grep checks if that line already exists before adding it.
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