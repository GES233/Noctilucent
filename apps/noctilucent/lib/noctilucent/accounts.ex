defmodule Noctilucent.Accounts do
  @moduledoc """
  关于账户的上下文。
  """

  import Ecto.Query, warn: false
  alias Noctilucent.Repo

  alias Noctilucent.Accounts.{User, UserToken} # UserNotifire

  ## 从数据库中获得信息

  @doc """
  返回所有的用户。

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  依照 id 返回单一的某个用户。

  如果用户不存在会抛出 `Ecto.NoResultsError` 。

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  通过用户名（不是昵称）获得用户。

  ### Examples
      iex> get_user_by_username("User")
      %User{}
      iex> get_user_by_username("invalid-username-that-not-exist")
      nil
  """
  def get_user_by_username(username) when is_binary(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  通过用户名以及密码获取用户。

  ## Examples

      iex> get_user_by_username_and_password("iKUNforever", "cxkjntm")
      %Member{}

      iex> get_user_by_username_and_password("iKUNforever", "cxknmjj")
      nil

  """
  def get_user_by_username_and_password(username, password)
      when is_binary(username) and is_binary(password) do
    user = Repo.get_by(User, username: username)
    if User.valid_password?(user, password), do: user
  end

  ## 用户注册

  @doc """
  注册用户。

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert!()
  end

  ## 用户设置

  @doc """
  执行更新用户名的操作。

  这个可能需要改，我的期望是用户名的更改需要重新
  确认用户身份（也就是重新输入密码）以及时间限制。
  """
  def do_change_username(user, username) do
    User.username_changeset(user, %{username: username})
  end

  # change_current/2
  def change_user_current(_user, _current) do
    raise Helpers.NotImplement
  end

  # change_nickname/2
  def change_user_nickname(_user, _nickname) do
    raise Helpers.NotImplement
  end

  # change_info/2
  def change_user_info(_user, _info_content) do
    raise Helpers.NotImplement
  end

  # change_gender/2
  def change_user_gender(_user, _gender) do
    raise Helpers.NotImplement
  end

  # change_user_gender_visibility/2
  def change_user_gender_visibility(_user, _visible) do
    raise Helpers.NotImplenent
  end

  # 这个需要 attrs 吗？
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_scene_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## 会话

  @doc """
  生成用于保存用户的 Token 。
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user, :storage_user)
    user_token
    |> Repo.insert()

    token
  end

  @doc """
  通过 Token 返回用户。
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token, :storage_user)
    Repo.one(query)
  end

  @doc """
  删除用户的 Token 。
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_scene_query(token, :storage_user))
    :ok
  end

  ## 重置密码
  # 略

  ## 用户状态的修改
  # TODO

  ## Misc

  # 我也不知道留这玩意有什么用
  @doc """
  为跟踪用户变化返回一个 `%Ecto.Changeset{}` 结构。

  和上面 `update_user/2` 的区别在于其不向数据库发送更改。

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

end
