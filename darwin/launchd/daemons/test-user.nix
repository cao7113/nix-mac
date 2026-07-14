{ pkgs, username, ... }:

{

  ## Test change running user
  # check by: ps aux <pid>
  # sudo log show --predicate 'process == "launchd" AND message CONTAINS "test.nix"' --last 5m

  system.activationScripts.postActivation.text = ''
    echo "--> Running post-activation tasks..."
    touch /tmp/test-user-daemon.log
    chown _postgres /tmp/test-user-daemon.log
    touch /tmp/test-user-daemon.err.log
    chown _postgres /tmp/test-user-daemon.err.log
    echo "--> Post-activation tasks completed."
  '';

  launchd.daemons.test-user-daemon = {
    serviceConfig = {
      # 遵循反向域名命名规范，确保系统唯一性
      Label = "test.nix.darwin.test-user-daemon";

      # 故障自愈：如果进程非预期退出，launchd 会自动拉起
      KeepAlive = true;

      UserName = "_postgres";

      # 这里的实现使用 printf 构建了符合 HTTP/1.1 RFC 标准的最小响应
      # 工业级实践：使用 ${pkgs.xxx} 引用绝对路径，消除对系统环境变量 PATH 的依赖
      # 特别注意：printf 中的 \r\n 是 HTTP 协议规范要求的换行符（CRLF）
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "while true; do printf \"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 31\r\nConnection: close\r\n\r\nHello from user Nix-Darwin Daemon\n\" | ${pkgs.netcat}/bin/nc -l 2001; done"
      ];

      # 日志路径：
      # 在 macOS 生产环境中，通常建议使用 /var/log/，但需预先配置权限。
      # 测试阶段使用 /tmp/ 以确保服务不会因为 log 写入权限问题而启动失败。
      StandardOutPath = "/tmp/test-user-daemon.log";
      StandardErrorPath = "/tmp/test-user-daemon.err.log";

      # 进程优先级：Background 表示低 CPU/IO 优先级，不影响系统响应速度
      ProcessType = "Background";
    };
  };
}
