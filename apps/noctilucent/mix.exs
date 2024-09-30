defmodule Noctilucent.MixProject do
  use Mix.Project

  def project do
    [
      app: :noctilucent,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs()
    ]
  end

  # 对 OTP 应用的配置
  #
  # 想要获得更多信息可输入 `mix help compile.app` 。
  def application do
    [
      mod: {Noctilucent.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # 指定不同环境要编译的路径。
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # 项目依赖。
  #
  # 输入 `mix help deps` 可查看范例与选项。
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:dns_cluster, "~> 0.1.1"},
      {:phoenix_pubsub, "~> 2.1"},
      {:ecto_sql, "~> 3.10"},
      {:ecto_sqlite3, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:helpers, in_umbrella: true},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end


  defp docs() do
    [
      extras: docs_extras(),
      groups_for_extras: groups_for_extras(),
    ]
  end

  defp docs_extras() do
    [
      "guides/user/overview.md",
      "guides/user/register.md",
      "guides/feed/format.md",
      "guides/feed/orgnise.md",
      "guides/room/overview.md",
      "guides/room/host_and_guest.md"
    ]
  end

  defp groups_for_extras() do
    [
      "用户": ~r/guides\/user\/.?/,
      "动态": ~r/guides\/feed\/.?/,
      "房间": ~r/guides\/room\/.?/,
    ]
  end

  # 别名（Alias）是专门用于当前项目的快捷方式或任务。
  #
  # 有关别名的更多信息，请参阅 `Mix` 的文档。
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run #{__DIR__}/priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
