#!/bin/bash

}

  mkdir -p ~/.config/git
}

set_file_association() {
  defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add \
}

configure_macos() {
  echo "This function configures macOS defaults."

  # Ask for 'sudo' authentication.
  if sudo --non-interactive true 2> /dev/null; then
  else
    echo -n "$(tput bold)When you’re ready to continue, insert your password. This is done upfront for the commands that require 'sudo'.$(tput sgr0) "
    sudo --validate
  fi

  # More options at https://github.com/mathiasbynens/dotfiles/blob/main/.macos.

  echo '- Expand save panel by default.'
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

  echo '- Expand print panel by default.'
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  echo '- Automatically quit printer app once the print jobs complete.'
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  echo '- Save to disk (not to iCloud) by default.'
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

  echo '- Disable Resume after reboot system-wide.'
  defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

  echo '- Prevent Safari from auto-opening "safe" files after download.'
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

  echo '- Set Help Viewer windows to non-floating mode.'
  defaults write com.apple.helpviewer DevMode -bool true

  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  echo '- Trackpad: enable tap to click for this user and for the login screen.'
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  echo '- Trackpad: map bottom right corner to right-click.'
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

  echo '- Set Home as the default location for new Finder windows.'
  defaults write com.apple.finder NewWindowTarget -string 'PfLo'
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

  echo '- Show all filename extensions in Finder.'
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  echo '- Disable the warning when changing a file extension.'
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  echo '- In Finder searches, search the current folder by default.'
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  echo '- Show path bar at bottom edge of Finder windows.'
  defaults write com.apple.finder ShowPathbar -bool true

  echo '- Avoid creating .DS_Store files on network or USB volumes.'
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  echo '- Disable disk image verification.'
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

  defaults write com.apple.dock show-recents -bool false

  echo '- Copy email addresses as foo@bar.com instead of Foo Bar <foo@bar.com> in Mail.app.'
  defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

  echo '- Disable inline mail attachments (just show the icons).'
  defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

  defaults write com.apple.screencapture disable-shadow -bool true

  echo '- Disable the "Are you sure you want to open this application?" dialog.'
  defaults write com.apple.LaunchServices LSQuarantine -bool false


  defaults write com.apple.PowerChime ChimeOnNoHardware -bool true
  killall PowerChime



}
