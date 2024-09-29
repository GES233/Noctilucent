defmodule NoctilucentWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use NoctilucentWeb, :controller
      use NoctilucentWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  # 静态路径
  # `~w` 是 Elixir 中的一个魔符
  # [魔符(Sigil) · Elixir School](https://elixirschool.com/zh-hans/lessons/basics/sigils)
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # 导入在处理管线里被用到的通用的连接以及控制器的函数
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: NoctilucentWeb.Layouts]

      import Plug.Conn
      use Gettext, backend: NoctilucentWeb.Gettext

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {NoctilucentWeb.Layouts, :app}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # 导入控制器的便捷函数
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # 导入渲染 HTML 时常用的帮助模块/函数
      unquote(html_helpers())
    end
  end

  # 和下面 verified_routes/0 不同的是，这个只有这个模块用到，
  # 所以用私有函数
  defp html_helpers do
    quote do
      # 规避 HTML 转义的功能
      import Phoenix.HTML
      # 核心 UI 组件（早晚要把这玩意儿换掉）以及翻译功能
      import NoctilucentWeb.CoreComponents
      use Gettext, backend: NoctilucentWeb.Gettext

      # Shortcut for generating JS commands
      # 生成 JS 命令的快捷方式（？）
      alias Phoenix.LiveView.JS

      # 生成路由以及 ~p 魔符
      unquote(verified_routes())
    end
  end

  # 轻量化使用 Phoenix.VerifiedRoutes
  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: NoctilucentWeb.Endpoint,
        router: NoctilucentWeb.Router,
        statics: NoctilucentWeb.static_paths()
    end
  end

  @doc """
  当被 `use Noctilucent, :blabla` 时，将特定的控制器/画面/等等发送到用它的地方。
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
    # 你 apply(Module, :func, [a]) 时，
    # 就等价于你 Module.func(a)
  end
end
