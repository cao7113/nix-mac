#!/usr/bin/env bash
set -euo pipefail

echo "=== 1. 正在针对国内波动网络注入骨底优化参数 ==="

# 💡 优化点 1：使用绝对路径，防止跨目录执行脚本时找不到本地文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
custom_conf="${SCRIPT_DIR}/conf/nix.custom.conf"

# 鲁棒性检查：如果文件不存在，提前报错，避免空变量传给安装器
if [[ ! -f "${custom_conf}" ]]; then
	echo "❌ 错误: 找不到配置文件 ${custom_conf}" >&2
	exit 1
fi

# 利用 Determinate 安装器原生支持的环境变量，把配置和抗干扰参数在一开始就锁死
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

echo "=== 2. 正在通过官方通道下载并安装 Determinate Nix 引擎 ==="
# Determinate 安装器自身只有十几兆，即使网络波动，几秒钟内也能下载完
# 💡 优化点 2：末尾加上 --no-confirm，实现完全无人值守的自动化脚本部署
curl -fsSL https://install.determinate.systems/nix | sh -s -- install # --no-confirm

echo "=== 🎉 Nix 引擎安装成功！国内加速与抗抖动配置已完美就绪 ==="
echo "提示：由于环境变量变更，请在新开终端或运行 'exec \$SHELL' 后再执行后续命令。"
echo '测试命令: nix run "nixpkgs#hello"'
