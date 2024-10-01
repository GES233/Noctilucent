defmodule Noctilucent.AuditLog do
  @moduledoc """
  类似于「岁月史书」的功能。

  *就怕有人搞事儿，等记住 IP 地址，连着逆天言行发给学校就老实了。*

  不抖机灵了，这种记录功能还是挺必要的。
  """
  use Ecto.Schema
  import Ecto.Changeset

  # 说实话，这块我没抄明白
  schema "audit_logs" do
    field :scope, :string
    field :context, :map, default: %{}
    field :params, :map, default: %{}
    field :verb, :string
    field :ip_addr, :string
    field :user_agent, :string
    # field :user, :id
    belongs_to :user, Noctilucent.Accounts.User

    timestamps(updated_at: false)
  end

  @_actions %{
    "account.user.login" => nil,
    "account.user.logout" => nil,
    "account.user.sign_in" => nil,
    "account.user.update_info.nickname" => nil,
    "account.user.update_info.gender" => nil,
    "account.user.update_info.info" => nil,
    "account.user.freeze" => nil,
    "account.user.delete_account" => nil,
  }

  @doc false
  def changeset(audit_log, attrs) do
    audit_log
    |> cast(attrs, [:verb, :scope, :ip_addr, :user_agent, :context, :params])
    |> validate_required([:verb, :scope, :ip_addr, :user_agent])
  end
end
