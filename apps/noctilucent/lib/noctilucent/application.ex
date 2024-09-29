defmodule Noctilucent.Application do
  # 想要查看更多可参阅 https://hexdocs.pm/elixir/Application.html
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Noctilucent.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:noctilucent, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:noctilucent, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Noctilucent.PubSub}
      # 输入 {Noctilucent.Worker, arg}，
      # 等同于调用 Noctilucent.Worker.start_link(arg)
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Noctilucent.Supervisor)
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
