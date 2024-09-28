defmodule Noctilucent.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
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
      # Start a worker by calling: Noctilucent.Worker.start_link(arg)
      # {Noctilucent.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Noctilucent.Supervisor)
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
