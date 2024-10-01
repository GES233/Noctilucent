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

等到你们能够看见项目的时候，大概率服务已经稳定了。所以如果想要干点什么的话（除了单纯 clone 外）最好注册个账号先。

当然，我假设你知道 [Git](https://git-scm.com/) 是什么以及关于它的一些基本用法。当然，如果不知道的话，可以看一下 [Git 教程 - 廖雪峰的官方网站](https://liaoxuefeng.com/books/git/introduction/index.html) 。

### 提问题

### 克隆代码

### 推送请求

## 在自己的设备上构建 Noctilucent

如果你有自己的想法但是发觉这个项目的代码并不像 Java 、 Python 那样好理解的话，请允许我向你安利一下 Elixir 。

Elixir 是一种基于 Erlang 虚拟机（BEAM）的动态、函数式编程语言，主要用于构建可扩展和维护性强的应用程序。它结合了 Erlang 的强大并发能力和简洁的语法，适合开发分布式系统和实时应用。

其在并发性以及实时性的优良表现也是我选择这门语言的原因之一（要不然 Vue + Python 它不香？）。

除此之外其提供了强大的宏系统，这显著加强了语言的表现力以及灵活性，其顺承于 Ruby 的语法（严格地讲，Elixir 的「语法」是被宏模拟出来的）可以以更加符合直觉的逻辑。

下面将简单的介绍 Noctilucent 的构建方法。

### 依赖项

Noctilucent 基于 [Phoenix](https://phoenixframework.org) 进行开发。除此之外其需要 C 语言编译工具以及网络条件进行静态资源的下载。

- Erlang/OTP
- Elixir
- Mix Archive
- C 语言工具链
  - MSVC（Windows） *mingw 试过，不行*
  - gcc（Linux）

管理依赖项的网站的服务器在境外，由于众所周知的原因，在国内如果没有特殊网络信道的话可能比较困难。但国内也有网站的镜像可以提供加速服务。

### 运行测试

略。

## 翻译

因为开发时的设计失误，虽然目前 Noctilucent 仅面向中文用户，我们在开发时的源代码（不是文档）使用英文。

因此需要对英文文档进行翻译以平衡开发者与用户的矛盾。

### 流程

执行以下脚本。

```sh
# gettext 只在 noctilucent_web 下安装，所以先把目录切换到这里
cd apps/noctilucent_web
# 提取文件
mix gettext.extract
# 生成目标语言的 PO 文件
mix gettext.merge priv/gettext --locale zh_CN
```

在 `apps/noctilucent_web/priv/gettext/zh_CN/LC_MESSAGES` 目录内，就可以翻译文件啦。

### 领域

略。

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
