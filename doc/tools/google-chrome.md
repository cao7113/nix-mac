# Google Chrome

* nix能安装google-chrome 插件吗，如bitwarden(不能，可使用Brave)
    - 登陆Google账号后，插件自动同步了，很好！
    - 书签也同步了，🎉！

* 设置google-chrome为默认浏览器的命令
    # 设置 Google Chrome 为默认
    open -a "Google Chrome" --args --make-default-browser
    # 如果是 Brave（之前讨论过的推荐选项）
    open -a "Brave Browser" --args --make-default-browser

    Mac SystemSetting -> Desktop and Deck -> Default web browser
    Chrome App: Setting -> Default browser