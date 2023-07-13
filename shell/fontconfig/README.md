# Fontconfig

字体配置

- Noto Sans Mono
  - 有良好的英文字形区分
- Fira Code
  - 有良好的英文字形区分，连字

- Noto Sans/Serif CJK SC
  - 可以显示大部分中文字体，避免字形缺失，且有宋体、黑体
- Noto Sans Mono CJK SC
  - 可以解决中英对齐问题，但0O区分不明显，英文偏瘦，基线过高
- Sarasa Term SC
  - 可以解决中英对齐问题，但英文偏瘦

- Nerd Font
  - 有丰富的图形

## 字体顺序

英文环境默认选中字体：

- `Serif: Noto Serif`
- `Sans-Serif: Noto Sans`
- `Monospace: Noto Sans Mono`

中文环境默认选中字体：

- `Serif: Noto Serif CJK SC`
- `Sans-Serif: Noto Sans CJK SC`
- `Monospace: Noto Sans Mono`

```sh
# `man fonts-conf`
# ~/.fonts.conf
# ~/.config/fontconfig/fonts.conf
    ~$ cp /dotfiles/pathto/.fonts.conf ~/.config/fontconfig/fonts.conf

# 安装一些本地字体
    ~$ cp -r /path/to/somefonts $HOME/.local/share/fonts
    ~$ fc-cache -fv

# 查看字体顺序列表
    ~$ fc-match -s monospace | head
    ~$ fc-match -s sans-serif | head
    ~$ fc-match -s serif | head

# 如果字体顺序有误，重新生成cache
    ~$ fc-cache -fv
    ~$ # 或者sudo执行
    ~$ sudo dpkg-reconfigure fontconfig fontconfig-config
```

**注意**：

`/etc/fonts/fonts.conf`及`/etc/fonts/conf.d/*`设置了系统字体的优先顺序

如`monospace`中文环境默认会选中`Noto Sans Mono CJK SC`，由`/etc/fonts/conf.d/70-fonts-noto-cjk.conf`配置，这是一款包含中文的等宽字体，其中的英文和数字是中文的一半宽度。

半宽英文一方面可以解决对齐问题，另一方面可能造成排版问题。

如GNOME的PDF阅读器`evince`使用的后端`poppler`，在中文环境中`Courier`等非内嵌的等宽字体会缺省为`monospace` -> `Noto Sans Mono CJK`导致排版问题，且其只遵循`fontconfig`的配置无法在应用内设置字体的缺省顺序。

事实上所有将字体缺省到`monospace`的应用都使用这款字体，而每个应用都重新设置显然不太方便，所以仍然需要使用`fontconfig fonts.conf`重新自定义字体顺序。

在`70-fonts-noto-cjk.conf`中直接修改会在字体更新时被覆盖，所以一般配置`/etc/fonts/local.conf`或`~/.config/fontconfig/fonts.conf`，详情参考`man fonts-conf`

## 中英字体对齐

如果确实需要中英字体对齐（如有缩进对齐的表格等），需要使用“X个汉字是Y个英文字母宽度”的字体，如比较常见的“一个汉字是两个英文字母宽度”的字体。

尽管在等高的情况下，如果一个汉字是英文字母的两倍宽度会显得太宽或间距太大，如果一个英文字母是一个汉字的一半宽度会显得太瘦，但这是中英字体对齐的一种较简单的办法，在不需要对齐的情况下可以不使用这样的等宽字体。

在终端环境中一般默认一个中文汉字是两个字母宽度，虽然字间距会稍微大一点，但是不需要专门使用中英对齐的字体（不同的终端模拟器可能不同）。

```sh
每个英文字母占一个字宽
每个中文汉字占两个字宽
Each English letter occupies a character width
Each Chinese character occupies two characters width

0123456789      0123456789
一二三四五      一二三四五
abcdefghij      abcdefghij

0123456789      0123456789
一二三abcd      一二三abcd
ab一c二d三      ab一c二d三
```

## 相似字形区分

```sh
aaaaaaaaaa \
oooooooooo \
OOOOOOOOOO \
0000000000 \
QQQQQQQQQQ \
CCCCCCCCCC \
GGGGGGGGGG \
iiiiiiiiii \
IIIIIIIIII \
llllllllll \
1111111111 \
|||||||||| \
丨丨丨丨丨(中文的 shu) \
gggggggggg \
9999999999 \
qqqqqqqqqq
```

## 字体异形

**注意**：现在Debian和Arch都在noto字体包中包含了语言配置如`/etc/fonts/conf.d/70-fonts-noto-cjk.conf`，不再需要手动设置noto字体的语种（但仍然需要设置Monospace的缺省顺序），中文环境会优先使用中文字体`Noto Sans CJK SC`。

参考链接：

- [`arch wiki`简体中文显示为异体字形](https://wiki.archlinux.org/title/Localization/Simplified_Chinese#Fixed_Simplified_Chinese_display_as_a_variant_(Japanese)_glyph)

```sh
# /etc/fonts/local.conf
    ~$ sudo cp /dotfiles/pathto/local.conf /etc/fonts/local.conf
    ~$ fc-cache -fv
    ~$ fc-match -s | grep 'CJK'
    ~$ # NotoSansCJK-Regular.ttc: "Noto Sans CJK SC" "Regular"
```
