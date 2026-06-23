#!/usr/bin/env zsh
# 显式开启 sh 兼容的某些行为（可选，但显式写出更稳健）
# Zsh 默认不执行单词拆分(Word Splitting)，这让带空格的变量更安全
set -euo pipefail

# zsh -c "$(curl -fsSL https://raw.githubusercontent.com/cao7113/nix-mac/main/setup.zsh)"
# cat setup.zsh | zsh -s
# dry run:  DRY_RUN=1 ./setup.zsh

# ==========================================
# 1. 全局配置与环境初始化
# ==========================================
NIX_MAC_DIR="${HOME}/nix-mac"
DRY_RUN="${DRY_RUN:-}"

# ==========================================
# 2. 核心架构函数 (工具集)
# ==========================================

log_step() { echo -e "\n\033[1;32m## $1\033[0m"; }
log_warn() { echo -e "\033[1;33m! $1\033[0m"; }
log_err() { echo -e "\033[1;31m[ERROR] $1\033[0m" >&2; }

# 统一的代理执行包装器
run_with_proxy() {
	local proxy_host=$(read_proxy_info "PROXY_HOST" "127.0.0.1")
	local proxy_port=$(read_proxy_info "PROXY_PORT" "1087")
	local proxy_socks_port=$(read_proxy_info "PROXY_SOCKS_PORT" "1086")

	# Zsh 中声明数组不需要带小括号（不过带了也兼容），这里保持标准的普通数组结构
	local proxy_settings=(
		"http_proxy=http://${proxy_host}:${proxy_port}"
		"https_proxy=http://${proxy_host}:${proxy_port}"
		"all_proxy=socks5h://${proxy_host}:${proxy_socks_port}"
		"no_proxy=localhost,127.0.0.1,local,.local"
	)

	if [[ -n "$DRY_RUN" ]]; then
		# Zsh 展开数组："${proxy_settings[@]}" 依然有效且安全
		echo "[DRY RUN] env ${proxy_settings[@]} $*"
		return 0
	fi

	if [[ -n "${SKIP_PROXY:-}" ]]; then
		echo "Skip proxy setting and directly run"
		"$@"
		return $?
	fi

	# 如果命令包含 sudo，特殊处理以确保环境变量安全注入
	if [ "$1" = "sudo" ]; then
		shift
		sudo env "${proxy_settings[@]}" "$@"
	else
		env "${proxy_settings[@]}" "$@"
	fi

	local exit_code=$?
	if [ $exit_code -ne 0 ]; then
		echo -e "\n[ERROR] Command failed with exit code $exit_code."
		echo "[DEBUG] Active proxy settings when failure occurred:"
		# Zsh 中获取数组长度使用 $#array_name
		if [ $#proxy_settings -eq 0 ]; then
			echo "  (No proxy variables defined in \${proxy_settings})"
		else
			for setting in "${proxy_settings[@]}"; do
				echo "  $setting"
			done
		fi
		echo ""
	fi
	return $exit_code
}

read_proxy_info() {
	if (($# < 2)); then
		echo "Usage: read_proxy_info <var-name> <default-value> , valid var-names PROXY_HOST PROXY_PORT PROXY_SOCKS_PORT" >&2
		return 1
	fi
	local valid_names=(PROXY_HOST PROXY_PORT PROXY_SOCKS_PORT)
	if [[ -z "${valid_names[(r)$1]}" ]]; then
		echo "Invalid name: $1, should in ${valid_names[@]}" >&2
		return 1
	fi

	local env_name="$1" default_val="$2"
	local proxy_dir="${HOME}/.nix-proxy-cache"
	local cache_file="${proxy_dir}/$env_name"

	# 【关键修改 1】Zsh 不支持 Bash 的 ${!var} 语法
	# Zsh 使用 ${(v)env_name} 或通过内建参数参数展开 ${(P)env_name} 来获取间接变量值
	local env_val="${(P)env_name:-}"
	if [ -n "$env_val" ]; then
		echo "$env_val"
		return
	fi

	local file_val=""
	if [ -f "$cache_file" ]; then
		file_val="$(<"$cache_file" 2>/dev/null)"
		if [ -n "$file_val" ]; then
			echo "$file_val"
			return
		fi
	fi

	# 如果是完全非交互式环境，不请求输入，直接使用默认值
	if [[ ! -t 0 ]]; then
		file_val="$default_val"
	else
		local input_val=""
		echo "请输入 $env_name [默认: ${default_val}]: " >&2
		# 【关键修改 2】Zsh 默认 read 行为与 Bash 不同
		# 为了向 /dev/tty 读取，Zsh 推荐在交互式下用 read -r "input_val?提示"
		# 或者依然通过重定向，但 Zsh 读 TTY 更加严谨：
		read -r input_val </dev/tty || input_val=""
		file_val="${input_val:-$default_val}"
	fi

	echo "# write $env_name input value $file_val into $cache_file" >&2
	mkdir -p "$(dirname "$cache_file")"
	echo -n "$file_val" >"$cache_file"
	echo "$file_val"
}

# ==========================================
# 3. 业务模块层 (符合幂等性设计)
# ==========================================

check_commands() {
	log_step "检查 required commands (注意：会失败，需要在图形界面完成xcode-select的安装，然后重试)"
	if command -v git &>/dev/null; then
		git --version
	else
		log_err "系统中未找到 git 命令！"
		exit 1
	fi
}

check_xcode_tools() {
	log_step "检查 Xcode Command Line Tools"
	if ! xcode-select -p &>/dev/null; then
		echo "正在安装 Xcode Command Line Tools..."

		xcode-select --install

		if [ -t 0 ]; then
			echo "请在弹出的系统窗口中完成安装，完成后按回车键继续..."
			# 【关键修改 3】Zsh 的 read 留空变量时，丢弃输入即可
			read -r
		else
			log_warn "检测到当前为非交互式环境（如 curl | zsh），已触发安装窗口。"
			log_warn "请在系统弹窗中完成 Xcode Tools 安装后，重新运行此脚本以继续后续步骤。"
			exit 1
		fi

		if ! xcode-select -p &>/dev/null; then
			log_err "Xcode Command Line Tools 未检测到安装，退出。"
			exit 1
		fi

	fi
	echo "✓ Xcode Command Line Tools 已就绪"
}

check_proxy() {
	local remote_url="https://www.google.com"
	log_step "验证网络代理可用性"
	if ! run_with_proxy curl -fsSL "$remote_url" --retry 2 --speed-limit 250000 --speed-time 3 -o /dev/null; then
		echo "https://github.com/shadowsocks/ShadowsocksX-NG"
		echo "https://github.com/shadowsocks/ShadowsocksX-NG/releases/download/v1.10.3/ShadowsocksX-NG.dmg"
		echo "Manually allow at: Settings -> Privacy & Security when open Shadowsocks"
		exit 1
	fi
	echo "✓ 代理网络连接测试成功 ${remote_url}"
}

ensure_homebrew() {
	log_step "检查/安装 Homebrew (允许跳过)"

	local brew_bin="/opt/homebrew/bin/brew"
	[[ ! -f "$brew_bin" && -f "/usr/local/bin/brew" ]] && brew_bin="/usr/local/bin/brew"

	if [[ -f "$brew_bin" ]]; then
		echo "✓ Homebrew 已存在: $brew_bin"
		return 0
	fi

	echo "未检测到 Homebrew，尝试非交互式安装..."
	local tmp_brew_sh="/tmp/brew-install.sh"

	if run_with_proxy curl -fsSL -o "$tmp_brew_sh" https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh; then
		chmod +x "$tmp_brew_sh"
		run_with_proxy NONINTERACTIVE=1 "$tmp_brew_sh" || log_warn "Homebrew 脚本执行返回了非零状态，尝试继续..."
	else
		log_warn "下载 Homebrew 安装脚本失败，跳过 Homebrew 安装。"
	fi
}

clone_nix_mac_repo() {
	log_step "同步 nix-mac 仓库"
	if [[ -d "$NIX_MAC_DIR" ]]; then
		echo "✓ nix-mac 目录已存在: $NIX_MAC_DIR"
	else
		echo "正在克隆仓库至 $NIX_MAC_DIR ..."
		run_with_proxy git clone https://github.com/cao7113/nix-mac.git "$NIX_MAC_DIR"
	fi
}

ensure_nix_installed() {
	log_step "检查 Nix 包管理器"
	local nix_bin="/nix/var/nix/profiles/default/bin/nix"

	if [[ -f "$nix_bin" ]] || command -v nix &>/dev/null; then
		echo "✓ Nix 已安装 $nix_bin"
		return 0
	fi

	local installer="$NIX_MAC_DIR/nix/installer/official-installer/setup.sh"
	if [[ -f "$installer" ]]; then
		echo "执行自定义 Nix 安装脚本..."
		chmod +x "$installer"
		run_with_proxy "$installer"
	else
		log_err "未找到 Nix 安装脚本: $installer"
		exit 1
	fi
}

bootstrap_nix_darwin() {
	log_step "初始化 nix-darwin 配置"

	if command -v gh &>/dev/null; then
		echo "✓ 检测到 gh 命令，判定 nix-mac 初始化配置已完成。"
		return 0
	fi

	local nix_bin="/nix/var/nix/profiles/default/bin/nix"
	run_with_proxy sudo "$nix_bin" run "nix-darwin/nix-darwin-26.05#darwin-rebuild" -- switch --impure --show-trace --flake "${NIX_MAC_DIR}#mac"

	# todo 中断重试？

	# nix build "nix-darwin/nix-darwin-26.05#darwin-rebuild" -vv --debug --no-link
	# ./result/darwin-rebuild ...
	# sudo nix run "nix-darwin/nix-darwin-26.05#darwin-rebuild" -- switch --flake ".#mac" --show-trace --impure
}

# ==========================================
# 4. 主程序入口执行控制
# ==========================================
main() {
	log_step "开始设置nix-mac工作环境"

	check_commands
	check_xcode_tools
	check_proxy
	ensure_homebrew
	clone_nix_mac_repo
	ensure_nix_installed
	bootstrap_nix_darwin

	log_step "🎉 恭喜！nix-mac 初始环境设置完成！"
	echo "后续更新参考: $NIX_MAC_DIR/deploy.zsh or mdp alias"
}

main "$@"
