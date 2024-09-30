import Config

# config/runtime.exs 在所有环境下都会被执行，包括在发布过程中。
# 它在编译后、系统启动前执行，因此通常用于从环境变量或其他地方加载
# 生产配置和秘密。不要在这里定义任何编译时配置，因为它们不会被应用。
# 下面的代码块包含生产环境的运行时配置。
if config_env() == :prod do
  database_path =
    System.get_env("DATABASE_PATH") ||
      raise """
      environment variable DATABASE_PATH is missing.
      For example: /etc/noctilucent/noctilucent.db
      """

  config :noctilucent, Noctilucent.Repo,
    database: database_path,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5")

  import Config


  # 密钥库用于签署/加密 cookie 和其他秘密。 config/dev.exs 和 config/test.exs
  # 中使用的是默认值，但你想在生产环境中使用不同的值，而且你很可能不想在版本控制中出现
  # 该值，因此我们使用环境变量来代替。
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :noctilucent_web, NoctilucentWeb.Endpoint,
    http: [
      # 启用 IPv6 且绑定所有接口。
      # 如果只想要本地访问请改成 {0, 0, 0, 0, 0, 0, 0, 1} 。
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base

  # ## 使用版本
  #
  # 如果要进行 OTP 发布，则需要指示 Phoenix 启动每个相关端点：
  #
  config :noctilucent_web, NoctilucentWeb.Endpoint, server: true
  #
  # 然后，你就可以调用 `mix release` 来组装发布。请参阅
  # `mix help release` 获取更多信息。

  # 纯内网部署，SSL 就不翻译了。
  # ## SSL 支持
  #
  # To get SSL working, you will need to add the `https` key
  # to your endpoint configuration:
  #
  #     config :noctilucent_web, NoctilucentWeb.Endpoint,
  #       https: [
  #         ...,
  #         port: 443,
  #         cipher_suite: :strong,
  #         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
  #         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
  #       ]
  #
  # The `cipher_suite` is set to `:strong` to support only the
  # latest and more secure SSL ciphers. This means old browsers
  # and clients may not be supported. You can set it to
  # `:compatible` for wider support.
  #
  # `:keyfile` and `:certfile` expect an absolute path to the key
  # and cert in disk or a relative path inside priv, for example
  # "priv/ssl/server.key". For all supported SSL configuration
  # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
  #
  # We also recommend setting `force_ssl` in your config/prod.exs,
  # ensuring no data is ever sent via http, always redirecting to https:
  #
  #     config :noctilucent_web, NoctilucentWeb.Endpoint,
  #       force_ssl: [hsts: true]
  #
  # Check `Plug.SSL` for all available options in `force_ssl`.

  config :noctilucent, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")
end
