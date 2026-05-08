{
  pkgs,
  config,
  username,
  inputs,
  ...
}:
let
  # Run as launchd.user.agents into ~/Libary/LaunchAgents/postgresql.plist
  # connect to PostgreSQL: psql postgres # \conninfo
  # ps aux <pid>
  # https://github.com/nix-darwin/nix-darwin/issues/339
  # https://github.com/nix-darwin/nix-darwin/blob/nix-darwin-25.11/modules/services/postgresql/default.nix
  # launchctl bootout gui/$(id -u)/org.nixos.postgresql
  # 注意：
  # - 不要纠结 MacOS 下预留的id _postgres, 开发环境下 用当前主用户最方便!(否则需要使用launchd.daemons重写nix-darwin中的services.postgresql模块)

  pgPkg = pkgs.postgresql_18;
  # dataDir = "/var/lib/postgresql/17";
  runAs = username; # config.system.primaryUser;
  pgUser = "postgres";
  pgPass = "postgres";
in
{
  ## postgresql 服务配置
  services.postgresql = {
    enable = true;

    # inherit dataDir;
    initdbArgs = [
      # We should really change the (internal) `superUser` option instead 🤔
      "-U ${runAs}"
    ];

    package = pgPkg;

    # WARNING: now not support initialScript, ensureDatabases, or ensureUsers

    # for postgresql.conf
    settings = {
      max_connections = 100;

      shared_buffers = "128MB";
      checkpoint_completion_target = 0.9;

      log_destination = "stderr";
      logging_collector = "on";
      log_directory = "log";
      log_filename = "postgresql-%Y-%m-%d_%H%M%S.log";
      log_statement = "all"; # 开发环境建议开启
      log_duration = "on"; # 记录查询耗时
    };

    authentication = pkgs.lib.mkForce ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
    '';
  };

  launchd.user.agents.postgresql.serviceConfig = {
    StandardErrorPath = "/tmp/postgres.error.log";
    StandardOutPath = "/tmp/postgres.log";
  };

  system.activationScripts.preActivation =
    let
      dataDir = config.services.postgresql.dataDir;
    in
    {
      enable = true;
      text = ''
        if [ ! -d "${dataDir}" ]; then
          echo "creating PostgreSQL data directory..."
          sudo mkdir -m 750 -p "${dataDir}"
          chown -R ${runAs}:wheel "${dataDir}"
        fi
      '';
    };

  # ==========================================================================
  # 应用层：Home Manager 配置 (客户端 & 自动化脚本)
  # ==========================================================================

  home-manager.users.${username} = {

    home.activation = {
      setupPostgresUser = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH="${pgPkg}/bin:$PATH"
        READY=0

        echo "PostgreSQL: Waiting for server to start..."
        for i in {1..30}; do
          if pg_isready -h localhost -p 5432 >/dev/null 2>&1; then
            echo "PostgreSQL: Server is ready!"
            READY=1
            break
          fi
          echo "PostgreSQL: Still waiting... ($i/30)"
          sleep 1
        done

        if [ "$READY" -eq 1 ]; then
          echo "PostgreSQL: Ensuring user '${pgUser}' and password are configured..."
          psql --no-psqlrc -h localhost -U ${runAs} -d postgres -tAc "
            DO \$$
            BEGIN
              IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '${pgUser}') THEN
                CREATE ROLE ${pgUser} WITH LOGIN SUPERUSER PASSWORD '${pgPass}';
              ELSE
                ALTER ROLE ${pgUser} WITH PASSWORD '${pgPass}';
              END IF;
            END \$$;" || true
            
          # create <runAs> database for handy psql connection
          DB_CHECK=$(psql --no-psqlrc -U ${runAs} -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${runAs}'")
          if [ "$DB_CHECK" != "1" ]; then
              psql --no-psqlrc -U ${runAs} -d postgres -c "CREATE DATABASE ${runAs}"
              echo "Database ${runAs} created."
          else
              echo "Database ${runAs} already exists."
          fi
        else
          echo "PostgreSQL: [ERROR] Server failed to start automatically."
          echo "Please check: launchctl list|grep postgresql"
        fi
      '';
    };

    ## Clients
    # 2026 放弃pgcli，使用psql或 harlequin 替代
    # Harlequin (pgcli 的最佳替代)  https://harlequin.sh/
    # TablePlus (如果你能接受 GUI) brew install --cask tableplus
    # Beekeeper Studio (另一个 GUI 选择) brew install --cask beekeeper-studio

    # 1. 安装基础工具
    home.packages = [
      pgPkg # psql, createdb, pg_isready, etc.
      pkgs.less

      # harlequin adapter postgres "host=localhost user=rj dbname=rj port=5432"
      # pkgs.harlequin
    ];

    home.shellAliases = {
      pg = "psql -h localhost -U ${runAs} -d postgres";
      pglogs = "tail -f ${config.services.postgresql.settings.log_directory}/postgresql-*.log";
    };

    # 2. 配置 psql 交互行为 (.psqlrc)
    # 使用 home.file 能够精确控制配置文件的每一行
    home.file.".psqlrc".text = ''
      -- 基础界面设置 (注释必须单独起行)
      \set QUIET 1

      -- 明确显示 NULL 值
      \pset null 'NULL'
      -- 使用增强型边框表格
      \pset border 2
      -- 使用 Unicode 线条
      \pset linestyle unicode
      -- 核心功能：列太多时自动切换垂直显示
      \x auto

      -- 提示符定制 (双百分号用于 Nix 转义)
      -- %n:用户, %m:主机, %/:数据库, %x:事务状态
      \set PROMPT1 '%%[%033[1;32m%]pg-%n@%m% %[%033[0m%]%[%033[1;34m%]%/% %[%033[1;33m%]%x%[%033[0m%]%# '

      -- 历史记录设置
      \set HISTFILE ~/.psql_history- :DBNAME
      \set HISTSIZE 5000
      -- 自动补齐关键词大写
      \set COMP_KEYWORD_CASE upper

      -- 常用查询快捷别名
      -- 查看表大小
      \set table_size 'SELECT relname AS "Table", pg_size_pretty(pg_total_relation_size(relid)) AS "Size" FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC;'
      -- 查看活跃连接
      \set active_queries 'SELECT pid, query_start, now() - query_start AS duration, query, state FROM pg_stat_activity WHERE state != \'idle\';'
      -- 快捷查询 :l demos;
      \set l 'SELECT * FROM'

      \set QUIET 0
      \echo 'psqlrc loaded.'
    '';

    # 3. 环境变量增强
    home.sessionVariables = {
      # 工业级分页设置：S(不折行), R(保留颜色), X(防止清屏), F(小内容不分页)
      PAGER = "less -SRXF";
      # 默认编辑器，输入 \e 时调用
      PSQL_EDITOR = "vim";
    };
  };

}
