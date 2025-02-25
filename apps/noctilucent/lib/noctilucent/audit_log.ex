defmodule Noctilucent.AuditLog.Context do
  @moduledoc """
  负责处理日志的上下文。
  """

  defmodule InvalidError do
    @moduledoc """
    当上下文不符合要求时抛出的异常。
    """

    defexception [:message]

    # 这个可以细一点
    # 检查给定的键所对应的上下文与输入有哪些不同
    @impl true
    def exception(term) do
      msg = case term do
        {:missing, missing_fields} ->
          "Missing fields: #{inspect(missing_fields)}"

        {:extra, extra_fields} ->
          "Extra fields: #{inspect(extra_fields)}"
      end

      %InvalidError{message: msg}
    end
  end

  # 保存的键，对于值的读取需要对应的函数来操作
  @params %{
    # 用户自发和账号相关的动作
    account: %{
      ## 基本功能
      # 登录
      "user.login" => ~w(new_token),
      # 登出
      "user.logout" => ~w(invalid_token),
      # 注册
      "user.sign_up" => ~w(username),
      # 修改用户信息
      "user.update_username" => ~w(username old_username),
      "user.update_info.nickname" => ~w(nickname),
      "user.update_info.gender" => ~w(gender),
      "user.update_info.info" => ~w(info),
      # 状态变化
      # 用户冻结
      "user.freeze" => ~w(exp_expire_time),
      # 删除账号
      "user.delete_account" => ~w(username)
    },
    # 社交相关
    social: %{
      # 关注/取关
      "user.follow" => ~w(follower_id followee_id),
      "user.unfollow" => ~w(origin_follower_id origin_followee_id),
      # 添加好友/删除好友
      "user.contact.add" => ~w(user_id contact_id),
      "user.contact.add.accept" => ~w(acceptor_id contact_id),
      "user.contact.add.reject" => ~w(rejector_id contact_id),
      "user.contact.remove" => ~w(user_id contact_id),
      # 拉黑/解除拉黑
      "user.block" => ~w(user_id block_id),
      "user.unblock" => ~w(user_id block_id)
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
      "responce.natural" => ~w(user_id content_type content_id)
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
    noctilucent: %{
      "" => []
    }
  }

  @doc """
  通过领域以及动作返回所需的上下文。
  """
  for {scope, actions_map} <- @params, {verb, action} <- actions_map do
    def by_scope_and_verb(unquote(scope), unquote(verb)), do: {:ok, unquote(action)}
  end

  def by_scope_and_verb(_scope, _verb), do: {:error, :not_found}

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

  ### 格式说明

  用户 `user` 或系统在 `insert_at` 时执行了有关 `scope` 领域的
  `verb` 行动，其上下文为 `context` 。

  上下文主要是被操作的对象（比方说管理员动用权限删除推文或封禁用户）
  的类别以及 ID 或者是相关的数据，在操作时需要被检查或验证。
  """
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset
  alias Noctilucent.Repo

  # 说实话，这块我没抄明白
  schema "audit_logs" do
    field :scope, Ecto.Enum, values: [:account, :content, :room]
    field :context, :map, default: %{}
    field :verb, :string
    field :ip_addr, EctoIP
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
  插入一条日志。
  """
  def audit!(audit_context, scope, verb, context) do
    Repo.insert!(build!(audit_context, scope, verb, context))
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

  # 调用相关模块实现检查功能
  alias Noctilucent.AuditLog.Context

  defp validate_context!(%__MODULE__{scope: scope, verb: verb, context: context} = struct) do
    with {:ok, valid_context} <- Context.by_scope_and_verb(scope, verb),
         actual_context <- context |> Map.keys() |> Enum.map(&to_string/1),
         {[], []} <- {actual_context -- valid_context, valid_context -- actual_context} do
      :ok
    else
      {:error, _} -> raise "Invalid scope and verb"

      {missing = [_ | _], _} ->
        raise Context.InvalidError, {:missing, missing}

      {_, extra} ->
        raise Context.InvalidError, {:extra, extra}
    end

    struct
  end
end
