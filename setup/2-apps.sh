#!/bin/bash

brew_install() {
  renew_sudo


  # Add brew command to current and future shell sessions.
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # shellcheck disable=SC2016

}
