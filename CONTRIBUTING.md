# 为 Noctilucent 做贡献

如果没有诸位的支持，这个项目根本无法孵化。

如果关于项目有更好的想法，或是想为项目添砖加瓦，非常欢迎你来与我们讨论这绝妙的点子；如果你有能力的话，我们更欢迎你直接 fork 项目，把你的点子狠狠地写进来，然后 pull requests 让我们感受一下。

你可以从以下三个角度来帮忙：

- 关于自己的问题与点子提 issue
- 翻译（包括来源于脚手架的英文注释以及 `apps/noctilucent_web/priv/gettext` 的本地化）
- 为项目提供代码（包括页面、前端资源以及后端的业务逻辑或基础设施）

## 基本流程

当前 Noctilucent 的代码管理服务基于 [Gitea](https://about.gitea.com/) 。运行服务的设备就是本人于 24 上半年购置的一台小主机。因为这一层原因可能深夜不会服务（已经断电了啊喂）。

也就是说最好不要在深夜来提 issue 或提交代码，因为根本连不上。

等到你们能够看见项目的时候，大概率服务已经稳定了。所以如果想要干点什么的话（除了单纯 clone 外
）最好注册个账号先。

当然，我假设你知道 [Git](https://git-scm.com/) 是什么以及关于它的一些基本用法。当然，如果不知道的话，可以看一下 [Git 教程 - 廖雪峰的官方网站](https://liaoxuefeng.com/books/git/introduction/index.html) 。

### 提问题

### 克隆代码

### 推送请求

## 在自己的设备上构建 Noctilucent

如果你有自己的想法但是发觉这个项目的代码并不像 Java 、 Python 那样好理解的话，请允许我向你安利一下 Elixir 。

TODO: introduct elixir

其在性能以及实时性的优良表现也是我选择这门语言的原因之一（要不然 Vue + Python 它不香？）。

### 依赖项

Noctilucent 基于 Phoenix 进行开发。所以其所依赖的 Erlang/OTP 、 Elixir 以及 esbuild/tailwind 是必需的。

同时， Noctilucent 的数据库采用的是 sqlite 。其 Elixir 接口需要 C 语言编译器。在 Windows 下需要 MSVC 的编译工具，并且每次执行 `mix deps.compile` 都需要调用 MSVC 的环境，因此建议使用 Linux 环境进行开发工作。

管理依赖项的网站的服务器在境外，由于众所周知的原因，在国内如果没有特殊网络信道的话可能比较困难。但国内也有网站的镜像可以提供加速服务。

### 运行测试

## 项目设计规范

略。

## 代码规范

### Javascript

略。

### Elixir

#### 模块

#### 文档

*专指 `*.ex/exs` 内模块与函数的文档。*

### `TODO`

### 测试

## 代码审查
