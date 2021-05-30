#!/bin/sh

cleanup_error_log() {
  sed -i '' -E '/^Password: /d;/#.*%/d;/\* \[new/d;/Cloning into/d;/Execute post install script?/d' "${ERROR_LOG}"
}

final_message() {

  echo "All automated scripts have finished.
    'stderr' has been logged to '${ERROR_LOG}'.

    Operations that must be completed manually:

    - Run './postInstall.sh'.
      Also, read it to make sure its options are still required.
  " | sed -E 's/ {4}//'
}
