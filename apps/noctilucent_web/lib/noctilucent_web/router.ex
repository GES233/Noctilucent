defmodule NoctilucentWeb.Router do
  use NoctilucentWeb, :router

  import NoctilucentWeb.RequestContext, only: [put_audit_context: 1]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NoctilucentWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # TODO: get_user
    plug :put_audit_context
  end

  pipeline :api do
    plug :accepts, ["json"]
    # get user and put audit context
  end

  scope "/", NoctilucentWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/components", PageController, :components
  end

  # 其他的范围也可以使用自定义的 plug 栈。
  # scope "/api", NoctilucentWeb do
  #   pipe_through :api
  # end

  # 在开发时启用 LiveDashboard
  if Application.compile_env(:noctilucent_web, :dev_routes) do
    # 如果要在生产中使用 LiveDashboard，则应将其置于身份验证之后，
    # 只允许管理员访问。如果你的应用程序还没有管理员专用部分，只要使用
    # SSL（无论如何都应该使用），就可以使用 Plug.BasicAuth 设置一些基本身份验证。
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NoctilucentWeb.Telemetry
    end

    scope "/" do
      pipe_through :browser

    # 用户相关
    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    # TODO: 改成 username
    # live "/users/:id/edit", UserLive.Index, :edit

    # live "/users/:id", UserLive.Show, :show
    # live "/users/:id/show/edit", UserLive.Show, :edit
    end
  end
end
