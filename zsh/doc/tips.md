# Quick tips

```
command -v git &> /dev/null && echo ok || echo "not found"
command -V git # give verbose

# zsh
if (( $+commands[git] )); then
    echo "git 存在"
fi
```