# Nix lang

- https://nix.dev/tutorials/nix-language#next-steps
- https://nix.dev/manual/nix/2.28/language/index.html

## snippets

```
let
  pkgs = import <nixpkgs> {};
in "${pkgs.nix}"


{ pkgs ? import <nixpkgs> {} }:
let
  message = "hello world";
in
pkgs.mkShellNoCC {
  packages = with pkgs; [ cowsay ];
  shellHook = ''
    cowsay ${message}
  '';
}
```

## 语法

- attrs内 ; 分隔 属性，而非,
- 函数结尾} 不放分号
- 可任意换行和空格，尽量使用nixfmt进行统一格式化

## packages

writeShellScriptBin
writeShellApplication
pkgs.runCommand
