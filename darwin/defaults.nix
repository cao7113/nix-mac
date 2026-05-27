{
  self,
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  # Mac system settings by `defaults` command
  system.defaults = {
    # check cmd: defaults read com.apple.dock autohide # return 1
    # killall Dock # or 重启 Dock 使其应用新设置
    dock.autohide = true;
    # defaults read com.apple.finder AppleShowAllExtensions
    # killall Finder # 重启 Finder 使其显示后缀
    finder.AppleShowAllExtensions = true;
    # defaults read -g AppleInterfaceStyle
    NSGlobalDomain.AppleInterfaceStyle = "Dark"; # 开启深色模式

    # NSGlobalDomain.AppleMeasurementUnit = "Centimeters";

    ## Trackpad 轻点以点按
    # SystemSettings -> Trackpad -> Point & Click -> Tap to click （Tap with one finger）
    # 核心配置：开启轻点以点按 Tap to click
    trackpad.Clicking = true;
    # 确保在登录界面（以及全局底层）也生效
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
  };

  # 激活配置时自动重启受影响 live 进程（如 Finder/Dock 等），让配置立即生效
  system.activationScripts.postActivation.text = ''
    echo "⚙️ 正在强行同步底层触控板所有隐藏域..."

    # 2. 核心补丁：强行刷写所有可能影响 Tap to Click 的硬件和用户域
    # 很多时候系统只读当前用户下的具体触控板配置，必须全部强制覆盖为 1 (开启)
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

    defaults write -g com.apple.mouse.tapBehavior -int 1
    defaults write com.apple.AppleMultitouchTrackpad tapBehavior -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad tapBehavior -int 1

    echo "🔄 触发偏好设置动态通知..."
    # 使用系统标准手段通知，不杀进程
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  # 键盘映射 todo
}
