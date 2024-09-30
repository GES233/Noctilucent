# Elixir 概览

> Elixir is a dynamic, functional language for building scalable and maintainable applications.

(TODO 简单的介绍语言)

## 介绍

### 语言的亮点与应用

### 语言运行环境的安装

*本段假定读者已经存在一定的编程基础，知道如何设置编程语言的开发环境。*

*推荐读者使用特殊信道访问国际互联网，因为本节需要的不少网站被架设在境外。*

#### 运行时

```elixir
platform = %{
  "Windows" => [via: "Scoop"],
  "Linux" => [via: ["asdf", :etc]]
}
dependencies = [
  "erlang" |> add_elixir()
]
```

#### 编辑器

(VSC/Neovim/Helix)

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
