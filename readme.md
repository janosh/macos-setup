# Setup Automation

## Purpose

This is a repo of shell scripts and dotfiles that when executed and copied into their respective destinations bring a clean install of macOS into a working-ready state.

## Install everything

```bash
bash -c "$(curl -fsSL 'https://raw.github.com/janosh/setup/master/install.sh')"
```

## Organisation

The most important files in this repo are:

```
.
├── install.sh
├── scripts/*
└── postInstall.sh
```

`./scripts` holds the shell scripts. Containing only functions, none of them will do anything if run on their own. `install.sh` brings them together in an automated fashion, sourcing all functions and running them in sequence.

If you wish to run only parts of the setup process, you need only source the appropriate scripts and run the respective functions.

## License

[MIT](license)

## Other useful commands

[To update macOS with minimal downtime](https://9to5mac.com/2017/07/20/how-to-update-mac-using-terminal), avoid installing new releases via the Mac App Store and instead run

```
sudo sh -c “softwareupdate -ia && reboot”
```

To update all `brew` apps and casks, run

```
brew upgrade && brew cask upgrade && brew cleanup
```
