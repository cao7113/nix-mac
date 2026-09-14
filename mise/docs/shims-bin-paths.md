# mise shims & bin-paths

什么是 mise shims，与bin-paths有什么关系？
mise还在使用shim吗，其工作原理是啥？

```
❯ ls -l ~/.local/share/mise/shims | head -n 5
lrwxr-xr-x@ - rj 2026-08-12 14:25 bun -> /Users/rj/.local/bin/mise
lrwxr-xr-x@ - rj 2026-08-12 14:25 bunx -> /Users/rj/.local/bin/mise
lrwxr-xr-x@ - rj 2026-08-12 14:25 ct_run -> /Users/rj/.local/bin/mise
lrwxr-xr-x@ - rj 2026-08-12 14:25 dialyzer -> /Users/rj/.local/bin/mise
lrwxr-xr-x@ - rj 2026-08-21 15:13 dlv -> /Users/rj/.local/bin/mise

❯ mise bin-paths | head -n 5
/Users/rj/.local/share/mise/installs/usage/latest
/Users/rj/.local/share/mise/installs/bun/1.3.14/bin
/Users/rj/.local/share/mise/installs/erlang/29.0.3/bin
/Users/rj/.local/share/mise/installs/elixir/1.20.2-otp-29/bin
/Users/rj/.local/share/mise/installs/elixir/1.20.2-otp-29/.mix/escripts
```