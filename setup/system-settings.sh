#!/bin/bash


trap 'exit 0' SIGINT # exit cleanly if aborted with ⌃c

}

osascript -e 'tell application "System Settings" to quit' &> /dev/null

'

request_settings 'Download other languages under Dictation.' com.apple.Keyboard-Settings.extension
request_settings 'Check what you want synced to iCloud.' com.apple.systempreferences.AppleIDSettings
request_settings 'Add printers.' com.apple.Print-Scan-Settings.extension
