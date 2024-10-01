defmodule Noctilucent.Accounts.UserToken do
  @moduledoc """
  用户令牌相关的领域模型与业务。本质上是阉割了的 `phx.gen.auth`
  的代码。

  令牌的部分令牌本体、令牌的拥有者以及使用场景。一个使用者在一个使用场景下
  只允许一个令牌（如果需要多设备同时登录的话，可能需要更多考虑，懒得管了）。

  不同的场景有不同的处理策略以及过期时间。

  主要有以下的使用场景：

  * `:storage_user`
  * `:temporally`
  """
  use Ecto.Schema
  # import Ecto.Changeset
  import Ecto.Query
  alias Noctilucent.Accounts.UserToken

  @hash_algorithm :sha3_256
  @rand_size 32

  # 一些令牌的有效期
  @session_validity_in_days 45
  @token_validity_in_days 7

  @doc """
  返回不同场景下的有效期。
  """
  def validity_in_days(scene)

  def validity_in_days(:storage_user), do: @session_validity_in_days
  def validity_in_days(:temporally), do: @token_validity_in_days

  # scene 令牌的使用场景：
  # - 存储当前用户
  # - 临时令牌
  @derive {Inspect, except: [:token]}
  schema "user_tokens" do
    field :scene, Ecto.Enum, values: [:storage_user, :temporally]
    field :token, :binary

    belongs_to :user, Noctilucent.Accounts.User, type: :binary_id

    timestamps()
  end

  ## TODO
  # 加一个 changeset 以便检查约束 bla bla
  # 也可能不需要

  def build_session_token(user, scene) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %UserToken{token: token, scene: scene, user_id: user.id}}
  end

  # TODO: make the query editable.
  def verify_session_token_query(token, scene) do
    days = validity_in_days(scene)

    query =
      from token in by_token_and_scene_query(token, scene),
        join: user in assoc(token, :user),
        where: token.inserted_at > ago(^days, "day"),
        select: user

    {:ok, query}
  end

  # TODO
  # 加一个 verify_refresh_token/2 还有 build_refresh_token/1

  def build_hashed_token(user, scene) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %UserToken{
       token: hashed_token,
       scene: scene,
       user_id: user.id
     }}
  end

  def hashed_token_query(token, scene) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)
        days = validity_in_days(scene)

        query =
          from token in by_user_and_scene_query(hashed_token, scene),
            join: user in assoc(token, :user),
            where: token.inserted_at > ago(^days, "day"),
            select: user

        {:ok, query}

      :error ->
        :error
    end
  end

  def by_token_and_scene_query(token, scene) do
    from UserToken, where: [token: ^token, scene: ^scene]
  end

  def by_user_and_scene_query(user, :all) do
    from t in UserToken, where: t.user_id == ^user.id
  end

  def by_user_and_scene_query(user, [_ | _] = scenes) do
    from t in UserToken, where: t.user_id == ^user.id and t.scene in ^scenes
  end
end
