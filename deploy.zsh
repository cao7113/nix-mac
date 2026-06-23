#!/usr/bin/env zsh
set -euo pipefail

# ==========================================
# 1. 全局配置与状态字典声明
# ==========================================
REPO_DIR="${0:A:h}"
STATE_FILE="${REPO_DIR}/.nix_mac_level"
VALID_LEVELS=(basic brewer brewer-more all)
SCRIPT_NAME=${0}

# 使用 Zsh 关联数组管理状态提示文案，避免臃肿的 case 套娃
typeset -A LEVEL_HINTS=(
	basic "仅配置基本工具和 Zsh，未激活 Homebrew 模块。"
	brewer "激活 Homebrew 本体并安装 VSCode, Ghostty 等核心常用工具。"
	brewer-more "安装 OrbStack, Notion 等大体量、重度网络依赖的 Cask。"
	all "完全体环境（包括 Google Chrome 等需要严格代理的边缘工具，需要登陆Apple ID）。"
)

log_step() { echo -e "\n\033[1;32m## $1\033[0m"; }
log_warn() { echo -e "\033[1;33m! $1\033[0m"; }
log_err() { echo -e "\033[1;31m[ERROR] $1\033[0m" >&2; }

# ==========================================
# 2. 核心底层函数 (100% 保留的原有 Proxy 逻辑)
# ==========================================

read_proxy_info() {
	local env_name="$1" default_val="$2"
	local proxy_dir="${HOME}/.nix-proxy-cache"
	local cache_file="${proxy_dir}/$env_name"

	local env_val="${(P)env_name:-}"
	[[ -n "$env_val" ]] && {
		echo "$env_val"
		return
	}

	local file_val=""
	if [[ -f "$cache_file" ]]; then
		file_val="$(<$cache_file)" 2>/dev/null
		[[ -n "$file_val" ]] && {
			echo "$file_val"
			return
		}
	fi

	if [[ ! -t 0 ]]; then
		file_val="$default_val"
	else
		local input_val=""
		echo "请输入 $env_name [默认: ${default_val}]: " >&2
		read -r input_val </dev/tty || input_val=""
		file_val="${input_val:-$default_val}"
	fi

	mkdir -p "${cache_file:h}"
	echo -n "$file_val" >"$cache_file"
	echo "$file_val"
}

run_with_proxy() {
	if [[ -n "${SKIP_PROXY:-}" ]]; then
		echo "Skip proxy setting and directly run: $@"
		"$@"
		return $?
	fi

	local proxy_host=$(read_proxy_info "PROXY_HOST" "127.0.0.1")
	local proxy_port=$(read_proxy_info "PROXY_PORT" "1087")
	local proxy_socks_port=$(read_proxy_info "PROXY_SOCKS_PORT" "1086")
	local proxy_settings=(
		"http_proxy=http://${proxy_host}:${proxy_port}"
		"https_proxy=http://${proxy_host}:${proxy_port}"
		"all_proxy=socks5h://${proxy_host}:${proxy_socks_port}"
		"no_proxy=localhost,127.0.0.1,local,.local"
	)

	if [[ -n "${DRY_RUN:-}" ]]; then
		echo "[DRY RUN] env ${proxy_settings[@]} $*"
		return 0
	fi

	if [[ "$1" = "sudo" ]]; then
		shift
		echo "## proxy run: sudo env ${proxy_settings[@]} $@"
		sudo env "${proxy_settings[@]}" "$@"
	else
		echo "## proxy run: sudo env ${proxy_settings[@]} $@"
		env "${proxy_settings[@]}" "$@"
	fi

	local exit_code=$?
	if [[ $exit_code -ne 0 ]]; then
		echo -e "\n[ERROR] Command failed with exit code $exit_code."
		echo "[DEBUG] Active env settings when failure occurred:"
		for setting in "${proxy_settings[@]}"; do
			echo "  $setting"
		done
		echo ""
	fi
	return $exit_code
}

# ==========================================
# 3. 优化后的状态流转模块
# ==========================================

show_usage_and_exit() {
	local cur="$1"
	echo "📝 当前状态说明: ${LEVEL_HINTS[$cur]:-未知状态}"
	echo "\n💡 [可用命令]:"
	echo "  ${SCRIPT_NAME} up          - 根据当前状态自动计算并升级到下一个级别"
	echo "  ${SCRIPT_NAME} apply       - 不改变当前级别，直接重新应用/刷新当前配置"
	echo "  ${SCRIPT_NAME} use <level> - 直接应用并维持指定的级别 (可选: ${VALID_LEVELS[*]})"
	exit 0
}

# 纯函数：计算目标状态，不污染外部任何全局变量
calculate_next_level() {
	local cur="$1" cmd="$2" spec="$3"

	case "$cmd" in
	up | next)
		case "$cur" in
		"basic") echo "brewer" ;;
		"brewer") echo "brewer-more" ;;
		*) echo "all" ;; # brewer-more 或 all 都收敛到 all
		esac
		;;
	a | apply)
		echo "$cur"
		;;
	use | goto)
		if [[ -z "$spec" || ((! ${VALID_LEVELS[(I)$spec]})) ]]; then
			log_err "use 命令必须指定合法的目标级别！(可选: ${VALID_LEVELS[*]})"
			exit 1
		fi
		echo "$spec"
		;;
	*)
		show_usage_and_exit "$cur"
		;;
	esac
}

# ==========================================
# 4. 主程序入口与编排
# ==========================================
main() {
	echo "============================================="
	echo "🍏 Nix-Mac 基于level的渐进式部署工具"
	echo "💡 Running cmd: $*"

	# 1. 干净地读取当前真实状态
	local current_level="basic"
	if [[ -f "$STATE_FILE" ]]; then
		local raw_level="$(<$STATE_FILE)"
		current_level="${${raw_level##[[:space:]]}%%[[:space:]]}"
	fi

	# 2. 纯粹管道式计算期望的目标状态
	local next_level=$(calculate_next_level "$current_level" "${1:-}" "${2:-}")

	log_step "准备应用配置至: [$next_level]"
	echo "说明: ${LEVEL_HINTS[$next_level]}"
	log_step "正在执行 darwin-rebuild switch..."

	# 3. 执行环境构建（业务变量 NIX_MAC_LEVEL 显式随命令传入底层）
	if run_with_proxy sudo NIX_MAC_LEVEL="$next_level" darwin-rebuild switch --flake "${REPO_DIR}#mac" --verbose --impure; then

		# 4. 【原子落盘】成功后一气呵成修改状态，无需再考虑异常回滚逻辑
		mkdir -p "${STATE_FILE:h}" && echo "$next_level" >"$STATE_FILE"

		echo "--------------------------------------------------"
		log_step "[$next_level] 级别部署成功！"
		echo "--------------------------------------------------"

		# 后置跟进说明
		case "$next_level" in
		"brewer") log_warn "后续提示: 核心环境已就绪。请确保您的代理软件开启了 LAN 共享，然后再次运行 ${SCRIPT_NAME} up 即可晋升到下一级。" ;;
		"brewer-more") log_warn "后续提示: 重度工具已下载完成。最后一步请确保全局代理畅通，然后运行 ${SCRIPT_NAME} up 达到完全体。" ;;
		"all") log_step "终点提示: 所有软件安装完毕！后续若有配置修改，直接执行常规的 ${SCRIPT_NAME} apply 即可。" ;;
		esac
	else
		log_err "部署失败！因采用原子隔离设计，本地状态文件未受污，依然维持在 [$current_level]。"
		exit 1
	fi
}

main "$@"
