#!/usr/bin/env zsh

# -------------------------------------------------------------------
# 脚本名称: bench-registry.sh (修复排序版)
# 作用: 修复之前的字符倒序Bug，采用纯数字升序(n)对耗时排序
# -------------------------------------------------------------------

# 公开的第三方中转源非常适合**个人开发、NAS（如飞牛fnOS、群晖）或临时 CI/CD 预检**。
# 但在严谨的生产环境中，建议组合使用：**本地自建 Harbor（作为 Pull-through Cache 缓存）+ 境内合规备案服务商**，
# 避免核心业务因第三方源临时下线或供应链污染而遭受影响。

# # 方案 A：使用毫秒镜像中转 (推荐，目前最稳)
# docker pull docker.1ms.run/library/postgres:17
# # 方案 B：使用轩辕社区公益源中转
# docker pull docker.xuanyuan.me/library/postgres:17

# # 通过中转脚本直接拉取并自动重命名
# bash <(curl -sSL https://raw.githubusercontent.com/wzshiming/docker-pull/master/docker-pull.sh) postgres:17

typeset -A results
typeset -a registry_urls

# docker pull ghcr.1ms.run/github/github-mcp-server
# docker pull k8s.1ms.run/pause:3.10
# https://<private-key>.mirror.aliyuncs.com # 已限制在公共情况下使用了？
# 基本全不能用了！！！

registry_urls=(
    # --- 💡 第一梯队：2026 社区/高校/第三方实测最稳、同步率最高的公开加速源 ---
    "https://docker.1ms.run                  (毫秒镜像-高可用公开加速源)"
    "https://docker.xuanyuan.me              (轩辕镜像-社区免费公益加速)"
    "https://docker.mirrors.sjtug.sjtu.edu.cn (上海交通大学开源站-高校老牌源)"
    "https://docker.m.daocloud.io            (DaoCloud-老牌开源社区公开源)"
    "https://atomhub.openatom.cn             (开放原子开源基金会AtomHub可信源)"
    "https://docker-0.unsee.tech             (UnseeTech-社区维护中转加速)"
    "https://docker.kejilion.pro             (Kejilion-科技狮社区公益加速源)"
    "https://hub.xdark.top                   (XDark-社区公共代理源)"

    # --- ☁️ 第二梯队：公有云厂商官方镜像源 (注意：部分源有特定的使用前置条件) ---
    "https://mirror.baidubce.com             (百度云-公网完全开放的公共镜像)"
    "https://ccr.ccs.tencentyun.com          (腾讯云-公网公共加速源)"
    "https://mirror.ccs.tencentyun.com       (腾讯云-限腾讯云内网CVM服务器访问)"
    "https://registry.hub.docker.com         (阿里云-需登录ACR控制台绑定个人特有Code域名)"

    # --- 🌐 第三梯队：各大官方 Registry 源 (作为无代理时的回源兜底测试) ---
    "https://registry-1.docker.io            (DockerHub-官方源)"
    "https://ghcr.io                         (GitHub-Container-Registry)"
    "https://gcr.io                          (Google-Container-Registry)"
    "https://quay.io                         (RedHat-Quay-Container-Registry)"
    "https://registry.k8s.io                 (Kubernetes-官方组件镜像源)"
    "https://public.ecr.aws                  (Amazon-Elastic-Container-Registry)"
)

TEST_PATH="/v2/library/postgres/manifests/18"

echo "==========================================================="
echo "   🚀 开始测试 Docker Registry 真实响应速度 (修复版)      "
echo "==========================================================="

# 用于存放用于排序的数组
typeset -a raw_scores

for item in "${registry_urls[@]}"; do
    local url="${item[(w)1]}"
    local name="${item[(w)2,-1]}"
    
    printf "正在测试: %-35s ... " "${name}"
    local time_cost=$(curl -o /dev/null -s -m 4 -w "%{time_total}" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" "${url}${TEST_PATH}")
    
    if [[ $? -ne 0 || "${time_cost}" == "0.000" ]]; then
        echo "❌ 测试超时或连接失败"
        # 失败赋予一个极大的数值用于垫底
        raw_scores+=("999.999|${name}|${url}")
    else
        printf "⏱️  %s 秒\n" "${time_cost}"
        raw_scores+=("${time_cost}|${name}|${url}")
    fi
done

echo "\n==========================================================="
echo "   📊 最终速度排名结果 (从快到慢)                          "
echo "==========================================================="

local rank=1
# (n) 代表以数字大小(Numeric Order)进行升序排序，完美解决4秒排在0.008秒前面的问题
for entry in ${(n)raw_scores}; do
    local cost="${entry%%|*}"
    local rest="${entry#*|}"
    local desc="${rest%%|*}"
    local current_url="${rest#*|}"
    
    if [[ "${cost}" == "999.999" ]]; then
        printf "[第%d名] ❌ %-30s | 状态: 无法连接 / 超时\n" ${rank} "${desc}"
    else
        printf "[第%d名] ⚡ %-30s | 耗时: %6s 秒 | URL: %s\n" ${rank} "${desc}" "${cost}" "${current_url}"
    fi
    ((rank++))
done
echo "==========================================================="