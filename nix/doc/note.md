# Note

```
getconf DARWIN_USER_TEMP_DIR
```


Nix 内部对顺序的定义有一个默认值：1000。
当你使用 lib.mkBefore 或 lib.mkAfter 时，它们在底层其实就是 lib.mkOrder 的包装
缩写：lib.mkBefore $\rightarrow$ 相当于 lib.mkOrder 500
默认不加修饰 $\rightarrow$ 相当于 lib.mkOrder 1000
lib.mkAfter $\rightarrow$ 相当于 lib.mkOrder 1500