import Config

# 尽在测试时移除 hash 算法的工作量
config :bcrypt_elixir, :rounds, 1

# 配置你的数据库
#
# 为了提供 CI 环境下内建测试分区，
# MIX_TEST_PARTITION 环境变量会被使用。
# 运行 `mix help test` 可获得更多信息。
config :noctilucent, Noctilucent.Repo,
  database: Path.expand("../noctilucent_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# 我们不需要在测试时运行服务器。
# 如果需要的话，可以启用下面的 `server` 选项。
config :noctilucent_web, NoctilucentWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Bh5QDP9rZrG76m7RJM4s4IYrlnyvEMkM+D7n46frSSD4YlAKLT/4tBNISvBd0ksj",
  server: false

# 在测试时只需要输出警告和错误信息
config :logger, level: :warning

# 在运行时初始化 plug ，以加快测试编译速度
config :phoenix, :plug_init_mode, :runtime

# 启用有用但可能昂贵的运行时检查
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
