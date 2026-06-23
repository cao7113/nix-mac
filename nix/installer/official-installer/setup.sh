#!/usr/bin/env bash
set -euo pipefail

echo "# 安装nix from ${BASH_SOURCE[0]}"

# https://github.com/NixOS/nix-installer#installer-settings
export NIX_INSTALLER_LOGGER=pretty
export NIX_INSTALLER_ENABLE_FLAKES=true
export NIX_INSTALLER_EXPLAIN=true
# export NIX_INSTALLER_VERBOSITY=true
# export NIX_INSTALLER_PROXY=http://localhost:1087

# 💡 优化点 1：使用绝对路径，防止跨目录执行脚本时找不到本地文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
custom_conf="${SCRIPT_DIR}/conf/nix.custom.conf"

# 鲁棒性检查：如果文件不存在，提前报错，避免空变量传给安装器
if [[ ! -f "${custom_conf}" ]]; then
	echo "❌ 错误: 找不到配置文件 ${custom_conf}" >&2
	exit 1
fi

# 写入额外的配置
export NIX_INSTALLER_EXTRA_CONF="$(<"${custom_conf}")"

# === 调试区 (如果你想验证原样写入，取消下面 3 行注释即可) ===
# printf "%s\n" "${NIX_INSTALLER_EXTRA_CONF}" > "tmp-conf.conf"
# cat tmp-conf.conf
# exit 0

# cat <<EOF >"tmp-conf.conf"
# ${NIX_INSTALLER_EXTRA_CONF}
# EOF
# cat tmp-conf.conf
# exit

tmpfile=$SCRIPT_DIR/install.sh
curl -o $tmpfile -sSfL -v https://artifacts.nixos.org/nix-installer
chmod +x $tmpfile
echo "# download install script to ./$tmpfile, you can directly run"

echo "One liner: curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes -vv"
$tmpfile install --enable-flakes -vv # --no-confirm

# warning: Nix search path entry '/nix/var/nix/profiles/per-user/root/channels' does not exist, ignoring
sudo mkdir -p /nix/var/nix/profiles/per-user/root/channels

echo "Start new session or . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
echo "nix --version"

echo "/nix/nix-installer uninstall --no-confirm # to uninstall"
echo "Contgrats! all end."
