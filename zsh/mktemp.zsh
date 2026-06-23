# 1. 创建临时文件并把名字存入变量
MY_TMP_FILE=$(mktemp ./tmp.XXXXXXXXXX)

# 2. 注册钩子：无论脚本是正常结束还是被 Ctrl+C 中断，都自动删除它
trap 'rm -f "$MY_TMP_FILE"' EXIT INT TERM

# 3. 愉快地使用它
echo "some data" > "$MY_TMP_FILE"