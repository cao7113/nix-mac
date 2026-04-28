{
  config,
  pkgs,
  lib,
  ...
}:
{
  # 管理包管理器本身 nix, use determinate now!!!

  # # disable to avoid conflict with determinate installed nix
  # nix.enable = false;
  # # nix.enable = true;

  # # Necessary for using flakes on this system.
  # nix.settings.experimental-features = "nix-command flakes";
  # # 自动优化存储（极其推荐） 自动优化 Store，删除重复文件
  # # 这会将 Nix Store 中完全相同的文件替换为硬链接，极大地节省磁盘空间
  # # 这是 Nix 最强大的特性之一。如果两个不同的软件都依赖同一个版本的某个库（例如某个特定的 .so 或 .dylib），Nix 会发现内容一致并只保留一份物理文件。对于配置较小的 MacBook 硬盘来说，这是必开项。
  # # nix.settings.auto-optimise-store = true;
  # nix.optimise.automatic = true;
  # # 限制 Nix 构建时的并行任务数（可选，防止构建时卡死系统）
  # nix.settings.max-jobs = "auto";

  ## 自动优化存储（删除重复项）
  # nix.optimise.at = "daily";

  # nix.gc = {
  #   # 启用自动垃圾回收,开启后，nix-darwin 会为你创建一个 LaunchDaemon。它会在后台静默运行，你不需要手动去管它。
  #   # automatic = true;
  #   # launchctl list | grep nix-gc
  #   # !!  nix.gc.automatic requires nix.enable

  #   # 配置执行频率
  #   # 每周日凌晨 2 点执行（你可以根据需要修改）
  #   interval = {
  #     Weekday = 0;
  #     Hour = 2;
  #     Minute = 0;
  #   };

  #   # 自动清理的策略
  #   # --delete-older-than 30d 表示删除 30 天以前且未被引用的构建结果
  #   options = "--delete-older-than 30d";
  # };
}
