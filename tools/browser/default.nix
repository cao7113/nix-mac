{
  config,
  pkgs,
  lib,
  username,
  need_least,
  ...
}:
{
  homebrew = {
    # 带着代理这样下载很快
    # brew install --cask google-chrome

    # Brave https://alternativeto.net/browse/all/?tag=web-browser
    # !!! require proxy!!!
    casks = lib.optionals (need_least "all") [
      "google-chrome"
    ];
  };

}
