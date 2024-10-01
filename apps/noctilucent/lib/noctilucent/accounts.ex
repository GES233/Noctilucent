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
    |> Repo.insert()
  end

  ## 用户设置

  @doc """
  更新用户名。
  """
  def change_username(user, attrs \\ %{}) do
    User.username_changeset(user, attrs)
  end

  # change_current/2

  # change_nickname/2

  # change_info/2

  # change_gender/2

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
    {token, user_token} = UserToken.build_session_token(user, "user_storage")
    Repo.insert!(user_token)
    token
  end

  @doc """
  通过 Token 返回用户。
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token, "user_storage")
    Repo.one(query)
  end

  @doc """
  删除用户的 Token 。
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_user_and_scene_query(token, ["user_storage"]))
    :ok
  end

  ## 重置密码

  @doc """
  创建一个用户。

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  更新用户（这是 `phx.gen.context` 自动生成的函数，依照业务需求要被改掉）。

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  删除用户（依照业务需要也会被改掉）。

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    # TODO: logical delete
    Repo.delete(user)
  end

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
