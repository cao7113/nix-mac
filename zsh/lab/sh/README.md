# sh

```
[ 用户输入 sh a.sh ]
       │
       ▼
 运行物理文件 /bin/sh (大小约 100KB 的壳程序)
       │
       ▼
 读取软链接 /private/var/select/sh 的指向
       │
       ▼
 发现指向了 /bin/bash
       │
       ▼
【核心魔法：re-exec】
 /bin/sh 进程在内存中直接变成 /bin/bash (并自动开启 --posix 降级兼容模式)
       │
       ▼
 最终由 bash 引擎严谨地执行了你的 a.sh
```

## Tips

- 即使file.sh首行是 `#!/bin/zsh`，如执行方式是`sh file.sh`，解释器依然是`sh`；如果按`./file.sh`执行则使用Shebang指定的zsh
- macOS下默认是`zsh`，但指定解释器时会使用指定的，只是Terminal窗口打开的默认回话使用的是zsh，如直接输入的`array=(a b c); echo $array[1]`是zsh语法
- macOS 下非常经典的“套娃”现象：macOS 下的 /bin/sh 确实就是 bash，但它是一个“被封印了超能力”的 bash。
- 当 bash 发现自己是以 sh 的名字被启动时，它会立刻开启兼容模式（POSIX mode），假装自己是当年那个古老、死板的 sh。
- 因为 GPLv3 协议等原因，macOS 的 bash 至今停留在古老的 3.2 版本

```
NAME
     sh – POSIX-compliant command interpreter

SYNOPSIS
     sh [options]

DESCRIPTION
     sh is a POSIX-compliant command interpreter (shell).  It is implemented by re-execing as either bash(1), dash(1), or zsh(1) as determined by the symbolic link located at /private/var/select/sh.  If
     /private/var/select/sh does not exist or does not point to a valid shell, sh will use one of the supported shells.


# /bin/sh 只是一个传话筒（壳程序），真正的苦力（执行引擎）依然是后台被唤醒的 bash。
rj@mac sh % ls -l /private/var/select/sh
lrwxr-xr-x  1 root  wheel  9 May 21 16:57 /private/var/select/sh -> /bin/bash

rj@mac sh % sh --version
GNU bash, version 3.2.57(1)-release (arm64-apple-darwin25)
Copyright (C) 2007 Free Software Foundation, Inc.
rj@mac sh % bash --version
GNU bash, version 3.2.57(1)-release (arm64-apple-darwin25)
Copyright (C) 2007 Free Software Foundation, Inc.

## 语法检查
rj@mac sh % sh -c 'echo <(echo "hello")'
sh: -c: line 0: syntax error near unexpected token `('
sh: -c: line 0: `echo <(echo "hello")'
rj@mac sh % bash -c 'echo <(echo "hello")'
/dev/fd/63
```