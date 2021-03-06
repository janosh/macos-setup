#!/bin/sh

# --- Helper functions ---

trap 'exit 0' SIGINT # exit cleanly if aborted with ⌃C

info() {
  echo "- ${1}"
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

set_file_association() {
  defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add \
  "{LSHandlerContentType=${1};LSHandlerRoleAll=${2};}"
}

# Initial message when starting the script.
echo "After running the main install script, this script will help configure the rest of macOS. It is divided into two parts:

  - Commands that will change settings without needing intervention.
  - Commands that will require manual interaction.

  The first part will simply output what it is doing (the action itself, not the commands).

  The second part will open the appropriate panels/apps, inform what needs to be done, and pause.
  Unless prefixed with the message 'ALL TABS', all changes can be performed in the opened tab.
  After the changes are done, close the app and the script will continue.
" | sed -E 's/ {2}//'

# Ask for 'sudo' authentication.
if sudo --non-interactive true 2> /dev/null; then
  read -r -s -n0 -p "$(tput bold)Some commands require 'sudo', but it seems you have already authenticated. When you’re ready to continue, press ↵.$(tput sgr0)"
  echo
else
  echo -n "$(tput bold)When you’re ready to continue, insert your password. This is done upfront for the commands that require 'sudo'.$(tput sgr0) "
  sudo --validate
fi

# --- First part ---
# More options on http://mths.be/macos.

info 'Expand save panel by default.'
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

info 'Expand print panel by default'
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

info 'Automatically quit printer app once the print jobs complete'
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

info 'Save to disk (not to iCloud) by default.'
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

info 'Disable smart quotes.'
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

info 'Disable Resume system-wide.'
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

info 'Disable the prompt "Are you sure you want to open this application?".'
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSQuaratine -bool false

info 'Disable the Gatekeeper prompt "{appname} cannot be opened because it is from an unidentified developer".'
sudo spctl --master-disable

info 'Prevent Gatekeeper from re-enabling itself after 30 days.'
# Changes System Preferences > Security & Privacy > General > Allow apps downloaded from.
sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool false

info 'Prevent Safari from auto-opening "safe" files after download.'
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

info 'Set Help Viewer windows to non-floating mode.'
defaults write com.apple.helpviewer DevMode -bool true

info 'Enable full keyboard access for all controls. In particular, enable Tab in modal dialogs.'
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

# Change default file associations (requires restart).
# See https://apple.stackexchange.com/a/123834.
set_file_association net.daringfireball.markdown com.microsoft.vscode
set_file_association public.plain-text com.microsoft.vscode
set_file_association public.mpeg-4 org.videolan.vlc
set_file_association public.html com.google.chrome
# /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework\
# /Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user

# Customize VLC settings
# Ensure the settings file exists (not created on install but on launch)
# by calling vlc with an invalid value for the interface option.
# Does nothing except create and populate the file
# ~/Library/Preferences/org.videolan.vlc/vlcrc
vlc -I none
# Enable dark mode and disable icon changes (like Christmas icon).
sed -i '' -E 's/#?macosx-interfacestyle=0/macosx-interfacestyle=1/' ~/Library/Preferences/org.videolan.vlc/vlcrc
sed -i '' -E 's/#?macosx-icon-change=1/macosx-icon-change=0/' ~/Library/Preferences/org.videolan.vlc/vlcrc
# use sed with double quotes for variable replacement and pipe as separator
# since variable contains forward slashes (https://askubuntu.com/a/508174)
sed -i '' -E "s|#?snapshot-path=.*|snapshot-path=$HOME/Desktop/|" ~/Library/Preferences/org.videolan.vlc/vlcrc
sed -i '' -E 's/#?snapshot-format=.*/snapshot-format=jpg/' ~/Library/Preferences/org.videolan.vlc/vlcrc

# Install iTerm dynamic profile.
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles \
  && ln dotfiles/iterm-profile.json ~/Library/Application\ Support/iTerm2/DynamicProfiles
# Make custom profile the default.
defaults write com.googlecode.iterm2 "Default Bookmark Guid" "73964F77-3452-4112-BE05-8A8F1ED9B50D"

for app in 'Dock' 'Finder'; do
  killall "${app}" &> /dev/null
done

info 'Enable OS dark mode.'
osascript -e 'tell application "System Events" to tell appearance preferences to set properties to {dark mode:true}'

# --- Second part ---
# Find values for System Preferences by opening the desired pane and running the following AppleScript:
# tell application "System Preferences" to return anchors of current pane

echo

# Auto-close any open System Preferences panes, to prevent them from
# overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

preferences_pane 'com.apple.preferences.Bluetooth'
request_preferences 'Add Bluetooth peripherals and show Bluetooth in menu bar.'

preferences_pane 'com.apple.preference.trackpad'
request_preferences 'ALL TABS: Set Trackpad preferences.'

preferences_pane_anchor 'Mouse' 'com.apple.preference.universalaccess'
request_preferences 'Under "Trackpad Options…", enable three finger drag.'

preferences_pane_anchor 'Dictation' 'com.apple.preference.keyboard'
request_preferences 'Download other languages.'

preferences_pane 'com.apple.preferences.AppleIDPrefPane'
request_preferences "Check what you want synced to iCloud."

preferences_pane 'com.apple.preferences.internetaccounts'
request_preferences 'Remove Game Center.'

preferences_pane 'com.apple.preferences.users'
request_preferences 'Turn off Guest User account.'

preferences_pane 'com.apple.preference.printfax'
request_preferences 'Add printers.'
