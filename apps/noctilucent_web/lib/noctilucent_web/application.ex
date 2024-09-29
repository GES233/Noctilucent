defmodule NoctilucentWeb.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NoctilucentWeb.Telemetry,
      # 通常把开始处理请求的进程放在最后一个条目
      NoctilucentWeb.Endpoint
    ]

    # 访问 https://hexdocs.pm/elixir/Supervisor.html
    # 去查阅其他的策略以及所支持的选项
    opts = [strategy: :one_for_one, name: NoctilucentWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # 当应用更新时告诉 Phoenix 更新端点的配置。
  @impl true
  def config_change(changed, _new, removed) do
    NoctilucentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
