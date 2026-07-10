{
  config,
  pkgs,
  lib,
  username,
  need_least,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  # use wg or wg-quick command

  # sudo wg-quick up ./wg0.conf
  # sudo wg-quick down ./wg0.conf
  # sudo wg show

  # # 2. 使用 launchd 创建后台守护进程
  # launchd.daemons.wireguard = {
  #   script = ''
  #     # 确保路径正确，指向 nix 商店中的 wg-quick
  #     exec ${pkgs.wireguard-tools}/bin/wg-quick up /etc/wireguard/wg0.conf
  #   '';

  #   serviceConfig = {
  #     RunAtLoad = true;
  #     KeepAlive = true;
  #     StandardOutPath = "/var/log/wireguard.log";
  #     StandardErrorPath = "/var/log/wireguard.err.log";
  #   };
  # };

}
