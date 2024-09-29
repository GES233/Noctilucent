defmodule Noctilucent.Accounts.UserToken do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Inspect, except: [:token]}
  schema "user_tokens" do
    field :type, Ecto.Enum, values: [:session, :token]
    field :context, :string
    field :token, :binary
    belongs_to :user, Noctilucent.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(user_token, attrs) do
    user_token
    |> cast(attrs, [:token, :context, :type])
    |> validate_required([:token, :context, :type])
  end
end
