# Mani

如果感觉 mani 的整体设计符合预期，最佳的实践方式是：
统一管理与批量操作：使用 mani (Go) 作为主 CLI（处理声明式仓库目录管理、mani exec 批量执行）。
快速跳转：在 .zshrc / Shell 中绑定一个轻量函数，用 mani list --paths | fzf 结合 cd 实现毫秒级选择跳转。
状态预览：把 onefetch 集成到 fzf 或 mani 的 preview 窗口中，跳转前直接预览该仓库的活跃时间与语言构成。
