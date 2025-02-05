defmodule Noctilucent.AuditLog.Context do
  @moduledoc """
  负责处理日志的上下文。
  """

  # 保存的键，对于值的读取需要对应的函数来操作
  @params %{
    # 用户自发和账号相关的动作
    account: %{
      ## 基本功能
      # 登录
      "user.login" => ~w(user_id),
      # 登出
      "user.logout" => ~w(user_id),
      # 注册
      "user.sign_up" => ~w(user_id username),
      # 修改用户信息
      "user.update_username" => ~w(user_id username old_username),
      "user.update_info.nickname" => ~w(user_id nickname),
      "user.update_info.gender" => ~w(user_id gender),
      "user.update_info.info" => ~w(user_id info),
      # 状态变化
      # 用户冻结
      "user.freeze" => ~w(user_id exp_expire_time),
      # 删除账号
      "user.delete_account" => ~w(user_id),
    },
    # 社交相关
    social: %{
      # 关注/取关
      "user.follow" => ~w(follower_id followee_id),
      "user.unfollow" => ~w(origin_follower_id origin_followee_id),
      # 添加好友/删除好友
      "user.contact.add" => ~w(user_id contact_id),
      "user.contact.remove" => ~w(user_id contact_id),
      # 拉黑/解除拉黑
      "user.block" => ~w(user_id block_id),
      "user.unblock" => ~w(user_id block_id),
    },
    # 管理员的动作
    moderator: %{
      ## 对用户的管理
      # 封禁/解封
      "user.ban" => ~w()
      ## 对内容的管理
    },
    # 内容相关
    content: %{
      # 内容的增删改查
      "content.create" => ~w(author_id content_type content_id),
      "content.update" => ~w(author_id content_type content_id),
      "content.delete" => ~w(author_id content_type content_id),
      # 锁定以及解除锁定
      "content.lock" => ~w(author_id content_type content_id),
      "content.unlock" => ~w(author_id content_type content_id),
      # 点赞点踩
      "responce.like" => ~w(user_id content_type content_id),
      "responce.dislike" => ~w(user_id content_type content_id),
      "responce.natural" => ~w(user_id content_type content_id),
      # 评论相关
    },
    # 房间相关
    streaming: %{
      # 创建
      "room.create" => ~w(host_id room_id)
      # 预定/开启/关闭
      # 邀请/同意/拒绝
      # 踢出/加入房间黑名单
    },
    # 系统自动执行的动作
    # noctilucent: %{}
  }

  @doc """
  通过领域以及动作返回所需的上下文。
  """
  for {scope, actions_map} <- @params, {verb, action} <- actions_map do
    def by_scope_and_verb(unquote(scope), unquote(verb)), do: {:ok, unquote(action)}
  end
  def by_scope_and_verb(_scope, _verb), do: {:error, :not_implement}

  @doc """
  返回领域下所有的动作及其对应的上下文。
  """
  for {scope, actions_map} <- @params do
    def by_scope(unquote(scope)), do: {:ok, unquote(Macro.escape(actions_map))}
  end
  def by_scope(_), do: {:error, :not_found}
end

defmodule Noctilucent.AuditLog do
  @moduledoc """
  类似于「岁月史书」的功能。

  *就怕有人搞事儿，等记住 IP 地址，连着逆天言行发给学校就老实了。*

  不抖机灵了，这种记录功能还是挺必要的。

  ### 格式说明

  用户 `user` 或系统在 `insert_at` 时执行了有关 `scope` 领域的
  `verb` 行动，其上下文为 `context` 。

  上下文主要是被操作的对象（比方说管理员动用权限删除推文或封禁用户）
  的类别以及 ID 或者是相关的数据，在操作时需要被检查或验证。
  """
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  # 说实话，这块我没抄明白
  # [TODO): IP <-> Ecto custome Type
  schema "audit_logs" do
    field :scope, Ecto.Enum, values: [:account, :content, :room]
    field :context, :map, default: %{}
    field :verb, :string
    field :ip_addr, :string
    field :user_agent, :string
    belongs_to :user, Noctilucent.Accounts.User, type: :binary_id

    timestamps(updated_at: false)
  end

  def blank(), do: %__MODULE__{}

  @doc false
  def changeset(audit_log, attrs) do
    audit_log
    |> cast(attrs, [:verb, :scope, :ip_addr, :user_agent, :context])
    |> validate_required([:verb, :scope, :ip_addr, :user_agent])
  end

  @doc """
  列出用户的所有记录。
  """
  def list_by_user(%Noctilucent.Accounts.User{} = user, clauses \\ []) do
    Noctilucent.Repo.all(
      from(__MODULE__, where: [user_id: ^user.id], where: ^clauses, order_by: [asc: :id])
    )
  end

  @doc """
  列出与用户无关的记录。
  """
  def list_all_from_system(clauses \\ []) do
    Noctilucent.Repo.all(
      from(a in __MODULE__,
        # where: is_nil(a.user_id),
        where: [context: :noctilucent],
        where: ^clauses,
        order_by: [asc: :id]
      )
    )
  end

  @doc """
  在操作中添加 Audit 日志。

  其最后一个参数可以是函数或上下文本身。

  前者需要提供一个能够从 Audit 以及数据库的返回结果对数据进行处理的函数。
  """
  def multi(multi, audit_context, scope, verb, callback_or_context)

  # 需要来自 Ecto 的查询结果
  def multi(multi, audit_context, scope, verb, function) when is_function(function, 2) do
    Ecto.Multi.run(multi, :audit, fn repo, res ->
      log = build!(function.(audit_context, res), scope, verb, %{})
      {:ok, repo.insert!(log)}
    end)
  end

  def multi(multi, audit_context, scope, verb, context) when is_map(context) do
    Ecto.Multi.insert(multi, :audit, fn _ ->
      build!(audit_context, scope, verb, context)
    end)
  end

  # 构造

  defp build!(%__MODULE__{} = audit_context, scope, verb, context)
      when is_atom(scope) and is_binary(verb) and is_map(context) do
    # 一般地讲，audit_context 已经包括了用户相关的信息
    %{
      audit_context
      | scope: scope,
        verb: verb,
        context: Map.merge(audit_context.context, context)
    }
    |> validate_context!()
  end

  # [TODO) 调用相关模块实现检查功能
  # alias Noctilucent.AuditLog.Context

  defp validate_context!(struct) do
    # 这边一旦出了问题，一般是开发者设计的锅
    # 直接 raise 就好
    struct

    # 记得确定键的类别是 atom 还是 string
    # 数据端是 string ，但是业务端用 atom 比较适合
    # （因为原子类型写起来比较方便）
  end

  # defp has_correct_context_with_scope_and_verb
end
