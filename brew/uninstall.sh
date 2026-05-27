#! /usr/bin/env bash

# if which brew > /dev/null; then
if true; then
  echo try uninstall brew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
  #/bin/bash uninstall.sh --help
else
  echo not installed
fi
