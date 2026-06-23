{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # 1. 明确告诉 nix-darwin，闭上它管底层引擎的嘴，完全交由determinate nix-installer管理
  nix.enable = false;

  # ----------------------------------------------------------------------------
  # 全局声明式定制：宿主机的网络行为 (nix.custom.conf)
  # ----------------------------------------------------------------------------
  # 接管 DetSys 预留的自定义配置文件，这样的好处：
  # 在仓库里修改了nix.custom.conf后，直接darwin-rebuild switch后就会生效，拒绝了直接修改/etc/nix/nix.custom.conf，可以在仓库中备份
  # 问题：修改了nix.custom.conf，对应的nix-daemon是否会自动重启，测试验证！
  environment.etc."nix/nix.custom.conf".source = conf/nix.custom.conf;

  # 2. 绕过 nix 模块，直接用系统层手段把 registry.json 强行丢进 /etc/nix/
  # 系统层保证nix引擎中的nixpkgs版本和nix-darwin中的一致，会影响nix profile add 等手工命令
  environment.etc."nix/registry.json".text = builtins.toJSON {
    version = 2;
    flakes = [
      {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        to = {
          # type": "tarball",
          # "url": "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable/nixexprs.tar.xz"
          type = "path";
          # 核心魔法：直接把当前 Flake 锁死的 nixpkgs 源码路径暴露给系统注册表
          path = "${inputs.nixpkgs}";
        };
      }
    ];
  };

  # 1. 彻底根治第一个警告：清除系统默认对传统 channels 的搜寻路径
  # warning: Nix search path entry '/nix/var/nix/profiles/per-user/root/channels' does not exist, ignoring
  # 强制让全局的 NIX_PATH 映射到你当前 Flake 锁死的本地 nixpkgs 源码上
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # 3. 绕过 nix 模块，直接在 macOS 全局环境变量里锁死 NIX_PATH
  environment.variables = {
    # nix-env等旧命令会依赖这个变量
    NIX_PATH = "nixpkgs=${inputs.nixpkgs}";

    # 在 Nix 架构中，环境变量 NIX_CONFIG 的优先级是至高无上的，它会直接无视并覆盖掉 nix.conf 和 DetSys 在内存中拼接出来的任何垃圾。
    # 这样运行时，整个 Nix 脑子里只有清华源，那个海外源直接在进程级别被抹杀了。
    # 强制所有终端里的 nix 命令在运行时，只认这两个国内源，彻底无视 DetSys 内存拼接的海外尾巴！
    NIX_CONFIG = "substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10 https://mirrors.ustc.edu.cn/nix-channels/store?priority=20";
  };

  # ----------------------------------------------------------------------------
  # 核心魔法：全自动重载与智能容错告警钩子 (Smart Auto-Restart & Fallback Hook)
  # ----------------------------------------------------------------------------
  system.activationScripts.postActivation.text = ''
    echo "⚙️ 正在无感重载 Nix 引擎自定义配置..."

    # 💡 极简、高效的高级闭环：
    # 尝试在 50 毫秒内强制踢除服务。如果因为任何未知原因失败，执行 || 后面的大括号块，
    # 打印保姆级的手动诊断与恢复指南，但最后使用 'true' 确保不卡死整个 darwin-rebuild 的部署流程。
    sudo /bin/launchctl kickstart -k system/systems.determinate.nix-daemon 2>/dev/null || {
      echo ""
      echo "❌ 警告: Nix-Daemon 自动重载失败！"
      echo "----------------------------------------------------------------------"
      echo " 这通常是由于系统的守护进程状态异常或 launchd 权限暂时锁死导致的。"
      echo " 请在部署完成后，复制并在终端手动执行以下命令进行恢复："
      echo ""
      echo "   👉 sudo launchctl kickstart -k system/systems.determinate.nix-daemon"
      echo ""
      echo " 如果问题依旧，请尝试执行以下命令重新加载服务配置文件："
      echo "   👉 sudo launchctl bootstrap system /Library/LaunchDaemons/systems.determinate.nix-daemon.plist"
      echo "----------------------------------------------------------------------"
      echo ""
    } || true

    echo "✅ Nix Daemon 配置重载指令处理完毕！"
  '';
}
