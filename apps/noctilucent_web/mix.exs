defmodule NoctilucentWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :noctilucent_web,
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

      # 文档
      name: "NoctilucentWeb",
      docs: docs()
    ]
  end

  # 对 OTP 应用的配置
  #
  # 想要获得更多信息可输入 `mix help compile.app` 。
  def application do
    [
      mod: {NoctilucentWeb.Application, []},
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
      {:phoenix, "~> 1.7.14"},
      {:phoenix_ecto, "~> 4.5"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      # TODO 升级到 {:phoenix_live_view, "~> 1.0.0"}, （前提是更新到了）
      {:phoenix_live_view, "~> 1.0.0-rc.1", override: true},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:noctilucent, in_umbrella: true},
      {:jason, "~> 1.2"},
      {:bandit, "~> 1.5"},
      {:ex_doc, "~> 0.19", only: :dev}
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
      "guides/lead_in.md",
      "guides/take_a_glance/overview.md",
      "guides/take_a_glance/basic_view_of_elixir.md",
      "guides/take_a_glance/phoenix_dictionary_structure.md",
      "guides/take_a_glance/plug_life_cycle.md",
      "guides/take_a_glance/next_step.md",
    ]
  end

  defp groups_for_extras() do
    [
      "一瞥": ~r/guides\/take_a_glance\/.?/,
      # "用户": ~r//,
      # Web 端主要讨论鉴权、消息推送以及密码加密之类的 infra
      # "内容": ~r//,
      # "实时": ~r//,
      # Phoenix.Channel 与 Phoenix.LiveView
    ]
  end

  # 别名（Alias）是专门用于当前项目的快捷方式或任务。
  #
  # 有关别名的更多信息，请参阅 `Mix` 的文档。
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind noctilucent_web", "esbuild noctilucent_web"],
      "assets.deploy": [
        "tailwind noctilucent_web --minify",
        "esbuild noctilucent_web --minify",
        "phx.digest"
      ]
    ]
  end
end
