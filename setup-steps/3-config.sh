#!/bin/sh

configure_zsh() {
  # Link .zshrc from dotfiles to home directory.
  # -f: Overwrite config if already exists.
  ln -f dotfiles/.zshrc ~

  # Install Oh My Zsh.
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

configure_git() {
  # Configure git username.
  git config --global user.name "${FULLNAME}"
  # Authenticate with GitHub.
  git config --global user.email "${EMAIL}"
  git config --global github.user "${GITHUB_HANDLE}"
  git config --global credential.helper osxkeychain

  # Hard-link global gitignore file into default location.
  mkdir -p ~/.config/git
  ln -f dotfiles/git-global-ignore ~/.config/git/ignore

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

configure_ssh() {
  mkdir -p ~/.ssh
  ln -f dotfiles/ssh_config ~/.ssh/config
}
