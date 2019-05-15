cleanup_brew() {
  rm -rf "$(brew --cache)"
}

cleanup_error_log() {
  sed -i '' -E '/^Password: /d;/#.*%/d;/\* \[new/d;/Cloning into/d;/Execute post install script?/d' "${error_log}"
}

final_message() {
  clear

  echo "All automated scripts have finished.
    'stderr' has been logged to '${error_log}'.

    Operations that must be completed manually:

    - Run 'bash postInstall.sh'.
      Also, read it to make sure its options are still required.
  " | sed -E 's/ {4}//'
}
