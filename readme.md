# Setup Automation

## Purpose

This repo contains shell scripts and config files which, when executed and copied into their respective destinations, bring a clean install of macOS into a working-ready state.

Adapted from [Vítor’s dotfiles](https://github.com/vitorgalvao/dotfiles).

## Usage

To run all automatic scripts in this repo:

```sh
zsh -c "$(curl -fsSL 'https://raw.github.com/janosh/setup/master/install.sh')"
```

If you've already cloned the repo locally:

```sh
./install.sh
```

## Organization

The important files in this repo are:

```text
.
├── install.sh
├── scripts/*
└── postInstall.sh
```

`./scripts` holds the shell scripts. Containing only functions, none of them will do anything if run on their own. `install.sh` brings them together by sourcing all functions and running them in sequence.

If you wish to run only parts of the setup process, source the appropriate script(s) and call the respective functions, e.g. `source scripts/2_apps.sh && brew_install`.

## Other useful commands

[To update macOS with minimal downtime](https://9to5mac.com/2017/07/20/how-to-update-mac-using-terminal), avoid installing new releases via the Mac App Store and instead run

```sh
sudo sh -c “softwareupdate -ia && reboot”
```

To update all `brew` apps and casks, run

```sh
brew upgrade && brew cask upgrade && brew cleanup
```
