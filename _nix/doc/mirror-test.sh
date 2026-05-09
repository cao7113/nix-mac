#!/usr/bin/env zsh

# 镜像站配置
typeset -A mirrors
mirrors=(
    "TUNA_Tsinghua"   "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "NJU_Nanjing"     "https://mirrors.nju.edu.cn/nix-channels/store"
    "Baidu_Cloud"     "https://mirror.baidu.com/nix-channels/store"
    "USTC_Hefei"      "https://mirrors.ustc.edu.cn/nix-channels/store"
    "Official_Global" "https://cache.nixos.org"
)

echo "----------------------------------------------------------------------"
echo "  Nix Mirror Connectivity & Latency Test"
echo "  Target: /nix-cache-info (Universal Metadata)"
echo "----------------------------------------------------------------------"
printf "%-20s | %-15s | %-12s\n" "Mirror Source" "Latency (TTFB)" "Status"
echo "----------------------------------------------------------------------"

for name url_base in ${(kv)mirrors}; do
    # 每个 Nix 缓存站都有这个元数据文件
    test_url="${url_base}/nix-cache-info"
    
    # -L: 自动跳转 (TUNA 常用)
    # -w: 格式化输出开始传输时间 (TTFB)
    stats=$(curl -L -s -o /dev/null -k -w "%{time_starttransfer}\t%{http_code}" "$test_url" --connect-timeout 5)
    
    time_taken=$(echo "$stats" | cut -f1)
    http_code=$(echo "$stats" | cut -f2)

    if [[ "$http_code" == "200" ]]; then
        printf "%-20s | \033[0;32m%-15s\033[0m | 🟢 OK\n" "$name" "${time_taken}s"
    elif [[ "$http_code" == "000" ]]; then
        printf "%-20s | \033[0;31m%-15s\033[0m | 🔴 TIMEOUT\n" "$name" "---"
    else
        printf "%-20s | \033[0;33m%-15s\033[0m | 🟡 HTTP $http_code\n" "$name" "---"
    fi
done

echo "----------------------------------------------------------------------"