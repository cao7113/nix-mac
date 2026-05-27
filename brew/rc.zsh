alias b="brew"

# export HOMEBREW_NO_AUTO_UPDATE=1

brew-prefix() {
  brew --prefix
  brew --repo
  echo "HOMEBREW_PREFIX=$HOMEBREW_PREFIX"
}

# brew commands
# brew install -v curl
# brew --env
# brew services
# https://github.com/eddiezane/lunchy. # ruby wrapper of launchctl

# download cache default dir 
# ~/Library/Caches/Homebrew/Cask

##################################################################
#    brew mirrors in China

# 很方便定位下载慢的问题
function brewup(){
  brew update --verbose --debug # --force
}

# brew install nmap --debug --verbose --dry-run

export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export BREW_PROXY=
function brewproxy(){
  echo BREW_PROXY=$BREW_PROXY
  brew_root=$(brew --repo)
  dirs=(
    / 
    /Library/Taps/homebrew/homebrew-core
    /Library/Taps/homebrew/homebrew-cask
  )
  for d in ${dirs[*]}; do 
    subd=${brew_root}${d}
    echo $(basename $subd) $(git -C "$subd" remote get-url origin)
  done
  echo Bottles $HOMEBREW_BOTTLE_DOMAIN  

  # brew config
}

function brewproxyreset(){
  export BREW_PROXY=official
  git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git
  # git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://github.com/Homebrew/homebrew-cask-fonts.git
  # git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin https://github.com/Homebrew/homebrew-cask-drivers.git
  unset HOMEBREW_BOTTLE_DOMAIN
}

# 推荐使用
# 科大源 https://mirrors.ustc.edu.cn/help/brew.git.html
function brewproxykeda(){
  export BREW_PROXY=ustc
  git  -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
}

# 清华源 https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
function brewproxyqinghua(){
  export BREW_PROXY=tsinghua
  git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
  # git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-fonts.git
  # git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-drivers.git
  # 预编译二进制
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
}

function brewuninstall() {
   echo "https://github.com/homebrew/install#uninstall-homebrew"
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
}

