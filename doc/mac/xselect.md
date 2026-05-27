## xcode-select

https://gemini.google.com/share/2e8ea75ed391

xcode-select --install
xcode-select: note: Command line tools are already installed. Use "Software Update" in System Settings or the softwareupdate command line interface to install updates

xcode-select -p
/Applications/Xcode.app/Contents/Developer

gcc --version
Apple clang version 21.0.0 (clang-2100.0.123.102)
Target: arm64-apple-darwin25.4.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

sudo xcode-select --reset

softwareupdate --list
Software Update Tool

Finding available software
Software Update found the following new or updated software:

- Label: Command Line Tools for Xcode 26.4-26.4
  Title: Command Line Tools for Xcode 26.4, Version: 26.4, Size: 920019KiB, Recommended: YES,

ls -l /Library/Developer/CommandLineTools

sudo softwareupdate -i "Command Line Tools for Xcode 26.4-26.4"

softwareupdate --list：查看是否有新的工具包。

sudo softwareupdate -i -a：安装所有系统更新。
