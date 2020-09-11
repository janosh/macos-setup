#!/bin/zsh

configure_zsh() {
  # Link .zshrc from dotfiles to home directory.
  ln dotfiles/.zshrc ~

  # Install Oh My Zsh.
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

configure_git() {
  # Make root directory user-writeable until restart. Required for next command.
  sudo mount -uw /
  # Remove Apple-pre-installed git (ensures newer brew-installed git is used instead).
  sudo rm /usr/bin/git

  # Configure git username.
  git config --global user.name "${git_name}"
  # Authenticate with GitHub.
  git config --global user.email "${github_email}"
  git config --global github.user "${github_username}"
  git config --global credential.helper osxkeychain

  # Hard-link gobal gitignore file into default location.
  ln dotfiles/git-global-ignore ~/.config/git/ignore

  # Use VSCode as git editor (e.g. for interactive rebase sessions).
  git config --global core.editor "code --wait"
  # Automatically create temporary stash entry before rebase begins. Reapply afterwards.
  # https://git-scm.com/docs/git-config#Documentation/git-config.txt-rebaseautoStash
  git config --global rebase.autoStash true
  # Automatically move fixup commits to the correct line during interactive rebase.
  git config --global rebase.autoSquash true

  # https://stackoverflow.com/a/3745250
  git config --global push.followTags true

  # How to reconcile divergent branches when pulling. Default is false, i.e. perform a merge.
  git config --global pull.rebase true
  # https://stackoverflow.com/a/62653400
  git config --global pull.ff only # fast-forward only
}

symlink_custom_scripts() {
  # uses symbolic link to be able to resolve local .env file holding iLovePDF API key via os.readlink()
  ln -s "$(pwd)/scripts/ilove_pdf_compress" /usr/local/bin
}

custom_app_icons() {
  typeset -A apps=(
    Handbrake Handbrake.icns
    Transmission Transmission.icns
    Tune•Instructor AppIcon.icns
    VLC vlc.icns
    Zotero Zotero.icns
  )

  for app icon_file_name in "${(kv)apps}"; do
    cp "appIcons/$app.icns" "/Applications/$app.app/Contents/Resources/$icon_file_name"
    touch "/Applications/$app.app"
    # Necessary to avoid the following error after icon change:
    # "{app} is damaged and can’t be opened. You should move it to the Trash"
    # See https://apple.stackexchange.com/a/300304.
    xattr -cr "/Applications/$app.app"
  done
}

configure_ssh() {
  renew_sudo

  # Disable locale environment variable forwarding to remote machine.
  # This avoids 'bash: warning: setlocale: LC_CTYPE: cannot change locale' when ssh'ing into
  # server with different locale settings. See https://askubuntu.com/a/144448.
  # -i '': Edit file in place with no backup.
  sudo sed -i '' '/SendEnv LANG LC_\*/ s/^#*/#/' /etc/ssh/ssh_config

  mkdir -p ~/.ssh
  ln dotfiles/ssh_config ~/.ssh/config
}