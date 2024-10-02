defmodule Noctilucent.AuditLog do
  @moduledoc """
  类似于「岁月史书」的功能。

  *就怕有人搞事儿，等记住 IP 地址，连着逆天言行发给学校就老实了。*

  不抖机灵了，这种记录功能还是挺必要的。

  ### 格式说明

  用户 `user` 或系统在 `insert_at` 时执行了有关 `scope` 领域的
  `verb` 行动，其上下文为 `context` ，相关在操作时需要被检查的参数是
  `params` 。

  上下文主要是被操作的对象（比方说管理员动用权限删除推文或封禁用户）
  的类别以及 ID 或者是相关的数据。

  params 则是为了验证操作（我抄的 Bytepack ，不知道 param 是不是还有必要）。
  """
  use Ecto.Schema
  import Ecto.Changeset
  # alias Noctilucent.AuditLog.{Context, Params}

  # 说实话，这块我没抄明白
  # [TODO): IP <-> Ecto custome Type
  schema "audit_logs" do
    field :scope, :string
    field :context, :map, default: %{}
    field :params, :map, default: %{}
    field :verb, :string
    field :ip_addr, :string
    field :user_agent, :string
    belongs_to :user, Noctilucent.Accounts.User, type: :binary_id

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(audit_log, attrs) do
    audit_log
    |> cast(attrs, [:verb, :scope, :ip_addr, :user_agent, :context, :params])
    |> validate_required([:verb, :scope, :ip_addr, :user_agent])
  end

  @doc """
  列出用户的所有记录。
  """
  def list_by_user(%Noctilucent.Accounts.User{} = user, clauses \\ []) do
    Noctilucent.Repo.all(
      from(__MODULE__,where: [user_id: ^user.id], where: ^clauses, order_by: [asc: :id])
    )
  end

  ## [TODO)
  # 把 Bytepack.AuditLog.multi/4 抄过来

  # 还有 build!
end
