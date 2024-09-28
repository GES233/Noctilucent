defmodule Noctilucent.Repo do
  use Ecto.Repo,
    otp_app: :noctilucent,
    adapter: Ecto.Adapters.SQLite3
end
