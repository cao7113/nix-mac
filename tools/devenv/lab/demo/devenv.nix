{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [ pkgs.postgresql ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # 启用 Postgres 服务
  services.postgres = {
    enable = true;
    initialDatabases = [
      { name = "testdb"; }
    ];
    # listen_addresses = "127.0.0.1";
  };

  # 定义一个简短的命令别名方便连接
  scripts.pgc.exec = ''
    # 这种方法最准：读取 Postgres 自动生成的 postmaster.pid 文件
    # 该文件的第 4 行通常是端口号
    PID_FILE="${config.env.DEVENV_STATE}/postgres/postmaster.pid"

    if [ -f "$PID_FILE" ]; then
      DETECTED_PORT=$(sed -n '4p' "$PID_FILE")
      echo "探测到 Postgres 运行端口: $DETECTED_PORT"
      psql -h 127.0.0.1 -p $DETECTED_PORT -d testdb
    else
      echo "未发现运行中的 Postgres，请先运行 devenv up"
    fi
  '';

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    # git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
