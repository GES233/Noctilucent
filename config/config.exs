# 通过 Config 模块的帮助，这个文件负责配置你的伞项目以及【所有的应用】
# 以及其依赖。
#
# 请注意，伞项目中的所有应用程序都共享相同的配置和依赖关系，这也是它们使用
# 相同配置文件的原因。如果你希望每个应用程序有不同的配置或依赖关系，最好将
# 这些应用程序移出保护伞。
import Config

# 配置 Mix 任务以及生成器
config :noctilucent,
  ecto_repos: [Noctilucent.Repo]

config :noctilucent_web,
  ecto_repos: [Noctilucent.Repo],
  generators: [context_app: :noctilucent]

# 配置端点
config :noctilucent_web, NoctilucentWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: NoctilucentWeb.ErrorHTML, json: NoctilucentWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Noctilucent.PubSub,
  live_view: [signing_salt: "49ZhXDbG"]

# 配置 esbuild （需要版本号）
config :esbuild,
  version: "0.17.11",
  noctilucent_web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/noctilucent_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# 配置 tailwind （需要版本号）
config :tailwind,
  version: "3.4.3",
  noctilucent_web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/noctilucent_web/assets", __DIR__)
  ]

# 配置 Elixir 日志
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# 在 Phoenix 中使用 Jason 来解析 JSON
config :phoenix, :json_library, Jason

# 将简体中文设置为缺省语言
# 当时就该 --no-gettext
config :gettext,
  default_locale: "zh_CN",
  locales: ~w(en zh_CN)

# 密码混淆的相关配置
config :bcrypt_elixir, rounds: 14

# 依据环境导入不同的配置。这一行必须在文件的最后
# 因此其可以覆写上面的配置。
import_config "#{config_env()}.exs"
