# Elixir 概览

> Elixir is a dynamic, functional language for building scalable and maintainable applications.

## 介绍

### 语言的亮点与应用

### 语言运行环境的安装

*本段假定读者已经存在一定的编程基础，知道如何设置编程语言的开发环境。*

*推荐读者使用特殊信道访问国际互联网，因为本节需要的不少网站被架设在境外。*

#### 运行时

如果你使用 Windows 且你的电脑拥有访问国际互联网的能力，强烈推荐 [scoop](https://scoop.sh) 这个面向 Windows 的包管理器。

在其安装完成后，你只需要简单的：

```powershell
scoop install erlang
scoop install elixir
```

就可以了。

根据 Elixir 官网给出的推荐，Linux 用户（包括 WSL2）可以使用 [asdf](https://github.com/asdf-vm/asdf) ，它也可以管理 erlang 以及 elixir 的版本。

#### 编辑器

小白无脑 [VSCode](https://code.visualstudio.com/) ，也可以用 [Neovim](https://neovim.io/) 或 [Helix](https://helix-editor.com/) （如果你选择后面两者，请确保知道自己在干什么）。

语言服务器推荐 [ElixirLS](https://github.com/elixir-lsp/elixir-ls) 。

### 哪些文件是 Elixir ？

(-.ex, .exs)

(-.eex, .heex)

## 推荐资料

### 语法速成

如果要在这里介绍 Elixir 的语法的话，可能要写很多。我相信大多数人并不喜欢看又臭又长的文字，再加上总有人比我写得好，所以这里就推荐更优秀的内容以及网站。

- [Erlang/Elixir语法速成 - 啊呜一口 - SegmentFault 思否](https://segmentfault.com/a/1190000012776435) （翻译自 [Erlang/Elixir Syntax: A Crash Course - The Elixir programming language](https://elixir-lang.org/crash-course.html)）
- [Learn Elixir in Y Minutes](https://learnxinyminutes.com/docs/zh-cn/elixir-cn/)
- [ElixirSchool](https://elixirschool.com/zh-hans)
- [RunElixir](https://runelixir.com/welcome.html)

### 练习

- [Exerism](https://exercism.org/tracks/elixir)
