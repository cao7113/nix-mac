# Direnv

- https://direnv.net/
- https://github.com/direnv/direnv
- https://github.com/direnv/direnv/blob/master/stdlib.sh
- https://github.com/direnv/direnv/wiki

## How it works?

> Before each prompt, direnv checks for the existence of a .envrc file (and optionally a .env file) in the current and parent directories. If the file exists (and is authorized), it is loaded into a bash sub-shell and all exported variables are then captured by direnv and then made available to the current shell.

## Config

It's also possible to create your own extensions by creating a bash file at ~/.config/direnv/direnvrc or ~/.config/direnv/lib/\*.sh. This file is loaded before your .envrc and thus allows you to make your own extensions to direnv.

```
# where direnv allow config store?
ls ~/.local/share/direnv/allow

## direnv 的加载顺序通常是：

- 加载内置的 stdlib。
- 加载 ~/.config/direnv/direnvrc（如果存在）。
- 加载 ~/.config/direnv/lib/*.sh。
```

## Setup

```
# in ~/.zshrc

# for zsh
eval "$(direnv hook zsh)"

# with omz
plugins=(... direnv)
```
