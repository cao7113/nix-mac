#! /bin/zsh
set -e # -x

# https://github.com/Homebrew/install
if which brew > /dev/null; then
  echo "brew already installed"
else
  echo "#### Start brew installing..."
  echo "https://docs.brew.sh/Installation#git-remote-mirroring"
  # export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
  # export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  #brew update
  echo "#### Brew installed"
fi

# error: Using the homebrew module requires homebrew installed, aborting activation
# Homebrew doesn't seem to be installed. Please install homebrew separately.
# You can install homebrew using the following command:

#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# if which task > /dev/null; then
#   echo "go-task already installed"
# else
#   # echo "install go-task by https://taskfile.dev"
#   # brew install go-task/tap/go-task
#   # https://taskfile.dev/installation/#homebrew
#   brew install go-task
#   echo "Task installed"
# fi

# echo "Congrats! Ready to go from Taskfile.yml!"


# ==> Downloading https://ghcr.io/v2/homebrew/core/portable-ruby/blobs/sha256:f41c72b891c40623f9d5cd2135f58a1b8a5c014ae04149888289409316276c72
# ###################################################################################### 100.0%
# ==> Pouring portable-ruby-4.0.2_1.arm64_big_sur.bottle.tar.gz
# ==> Installation successful!

# ==> Homebrew has enabled anonymous aggregate formulae and cask analytics.
# Read the analytics documentation (and how to opt-out) here:
#   https://docs.brew.sh/Analytics
# No analytics data has been sent yet (nor will any be during this install run).

# ==> Homebrew is run entirely by unpaid volunteers. Please consider donating:
#   https://github.com/Homebrew/brew#donations

# ==> Next steps:
# - Run these commands in your terminal to add Homebrew to your PATH:
#     echo >> /Users/rj/.zprofile
#     echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> /Users/rj/.zprofile
#     eval "$(/opt/homebrew/bin/brew shellenv zsh)"
# - Run brew help to get started
# - Further documentation:
#     https://docs.brew.sh