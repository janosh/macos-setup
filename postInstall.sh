#!/bin/zsh

# Helper functions.
trap 'exit 0' SIGINT # exit cleanly if aborted with ⌃C

info() {
  echo "$(tput setaf 2)•$(tput sgr0) ${1}"
}

request() { # Output a message and open an app.
  local message="${1}"
  local app="${2}"
  shift 2

  echo "$(tput setaf 5)•$(tput sgr0) ${message}"
  open -Wa "${app}" --args "$@" # Don't continue until app closes.
}

request_preferences() { # 'request' for System Preferences.
  request "${1}" 'System Preferences'
}

preferences_pane() { # Open 'System Preferences' in specified pane.
  osascript -e "tell application \"System Preferences\"
    reveal pane \"${1}\"
    activate
  end tell" &> /dev/null
}

preferences_pane_anchor() { # Open 'System Preferences' in specified pane and tab.
  osascript -e "tell application \"System Preferences\"
    reveal anchor \"${1}\" of pane \"${2}\"
    activate
  end tell" &> /dev/null
}

clear

# Initial message when starting the script.
echo "After running the main install script, this script will help configure the rest of macOS. It is divided in two parts:

  $(tput setaf 2)•$(tput sgr0) Commands that will change settings without needing intervention.
  $(tput setaf 5)•$(tput sgr0) Commands that will require manual interaction.

  The first part will simply output what it is doing (the action itself, not the commands).

  The second part will open the appropriate panels/apps, inform what needs to be done, and pause.
  Unless prefixed with the message 'ALL TABS', all changes can be performed in the opened tab.
  After the changes are done, close the app and the script will continue.
" | sed -E 's/ {2}//'

# Ask for 'sudo' authentication.
if sudo --non-interactive true 2> /dev/null; then
  read -s -n0 -p "$(tput bold)Some commands require 'sudo', but it seems you have already authenticated. When you’re ready to continue, press ↵.$(tput sgr0)"
  echo
else
  echo -n "$(tput bold)When you’re ready to continue, insert your password. This is done upfront for the commands that require 'sudo'.$(tput sgr0) "
  sudo --validate
fi

# --- First part ---
# More options on http://mths.be/macos.

info 'Expand save panel by default.'
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

info 'Save to disk (not to iCloud) by default.'
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

info 'Disable Resume system-wide.'
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

info 'Disable the “Are you sure you want to open this application?” dialog'
defaults write com.apple.LaunchServices LSQuarantine -bool false

info 'Enable full keyboard access for all controls.'
# In particular, enable Tab in modal dialogs.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

info 'Trackpad: enable tap to click for this user and for the login screen'
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

info 'Trackpad: map bottom right corner to right-click'
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

info 'Set Home as the default location for new Finder windows.'
defaults write com.apple.finder NewWindowTarget -string 'PfLo'
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

info 'Show all filename extensions in Finder.'
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

info 'Disable the warning when changing a file extension.'
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

info 'Use columns view in all Finder windows by default.'
# Four-letter codes for the other view modes: 'icnv', 'Nlsv', 'Flwv'
defaults write com.apple.finder FXPreferredViewStyle -string 'clmv'

for app in 'Dock' 'Finder'; do
  killall "${app}" &> /dev/null
done

info 'Set dark menu bar and Dock.'
osascript -e 'tell application "System Events" to tell appearance preferences to set properties to {dark mode:true}'

info 'Set Dock size and screen edge.'
osascript -e 'tell application "System Events" to tell dock preferences to set properties to {dock size:0.17, screen edge:left}'

# --- Second part ---
# Find values for System Preferences by opening the desired pane and running the following AppleScript:
# tell application "System Preferences" to return anchors of current pane

echo

request 'Allow to send and receive SMS messages.' 'Messages'

preferences_pane 'com.apple.preference.dock'
request_preferences 'Always prefer tabs when opening documents.'

preferences_pane 'com.apple.preference.displays'
request_preferences 'Turn off showing mirroring options in the menu bar.'

preferences_pane_anchor 'Dictation' 'com.apple.preference.keyboard'
request_preferences 'Download other languages.'

preferences_pane 'com.apple.preference.trackpad'
request_preferences 'ALL TABS: Set Trackpad preferences.'

preferences_pane 'com.apple.preferences.icloud'
request_preferences "Check what you want synced to iCloud."

preferences_pane 'com.apple.preferences.internetaccounts'
request_preferences 'Remove Game Center.'

preferences_pane 'com.apple.preferences.users'
request_preferences 'Turn off Guest User account.'

preferences_pane_anchor 'Mouse' 'com.apple.preference.universalaccess'
request_preferences 'Under "Trackpad Options…", enable three finger drag.'
