{ pkgs, username, ... }:

{
  # ============================================================================
  # 1. LaunchDaemon (系统级服务) - 由 nix-darwin 管理
  # ----------------------------------------------------------------------------
  # 位置: /Library/LaunchDaemons/test.nix.darwin.test-daemon.plist
  # 权限: 以 root 用户运行，随系统启动 (System-wide)
  # 常用维护命令:
  #   - 查看配置: cat /Library/LaunchDaemons/test.nix.darwin.test-daemon.plist
  #   - 检查状态: sudo launchctl list | grep test-daemon
  #   - 强制重启: sudo launchctl kickstart -k system/test.nix.darwin.test-daemon
  #   - 访问测试: curl -i http://127.0.0.1:8888/
  # ============================================================================

  launchd.daemons.test-daemon = {
    serviceConfig = {
      # 遵循反向域名命名规范，确保系统唯一性
      Label = "test.nix.darwin.test-daemon";

      # 故障自愈：如果进程非预期退出，launchd 会自动拉起
      KeepAlive = true;

      # 这里的实现使用 printf 构建了符合 HTTP/1.1 RFC 标准的最小响应
      # 工业级实践：使用 ${pkgs.xxx} 引用绝对路径，消除对系统环境变量 PATH 的依赖
      # 特别注意：printf 中的 \r\n 是 HTTP 协议规范要求的换行符（CRLF）
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "while true; do printf \"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 31\r\nConnection: close\r\n\r\nHello from Nix-Darwin Daemon\n\" | ${pkgs.netcat}/bin/nc -l 2000; done"
      ];

      # 日志路径：
      # 在 macOS 生产环境中，通常建议使用 /var/log/，但需预先配置权限。
      # 测试阶段使用 /tmp/ 以确保服务不会因为 log 写入权限问题而启动失败。
      StandardOutPath = "/tmp/test-daemon.log";
      StandardErrorPath = "/tmp/test-daemon.err.log";

      # 进程优先级：Background 表示低 CPU/IO 优先级，不影响系统响应速度
      ProcessType = "Background";
    };
  };

  # ============================================================================
  # 2. LaunchAgent (用户级服务) - 由 Home Manager 管理
  # ----------------------------------------------------------------------------
  # 位置: ~/Library/LaunchAgents/test.nix.home.test-agent.plist
  # 权限: 以当前用户 ${username} 运行，用户登录时加载
  # 常用维护命令:
  #   - 查看配置: cat ~/Library/LaunchAgents/test.nix.home.test-agent.plist
  #   - 实时查看日志: tail -f /tmp/test-cron-agent.log
  #   - 检查加载状态: launchctl list | grep test-agent
  # ============================================================================

  home-manager.users.${username} = {

    launchd.agents.test-cron-agent = {
      enable = true;
      config = {
        Label = "test.nix.home.test-cron-agent";

        # 核心业务逻辑：每隔 30 秒向指定文件追加时间戳
        # 工业级实践：${pkgs.coreutils}/bin/date 确保了不同机器上命令版本的一致性（GNU vs BSD）
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "echo \"Current time: $(${pkgs.coreutils}/bin/date)\" >> /tmp/test-cron-agent.log"
        ];

        # 调度策略：30 秒周期触发
        # 注意：macOS launchd 在系统休眠时会暂停计时，唤醒后立即补执行一次
        StartInterval = 30;

        # 调试日志：记录该 Agent 自身的输出与错误
        StandardOutPath = "/tmp/test-cron-agent.log";
        StandardErrorPath = "/tmp/test-cron-agent.err.log";

        # 激活策略：用户登录（Load）时立即运行一次，不等待第一个间隔周期
        RunAtLoad = true;

        # 性能优化：限制内存使用上限（可选，防止脚本逻辑错误导致 OOM）
        # SoftResourceLimits.MemorySoftLimit = 1024 * 1024 * 50; # 50MB
      };
    };

  };
}
