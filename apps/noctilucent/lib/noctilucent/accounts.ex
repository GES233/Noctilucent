defmodule Noctilucent.Accounts do
  @moduledoc """
  关于账户的上下文。
  """

  import Ecto.Query, warn: false
  alias Noctilucent.Repo

  alias Noctilucent.Accounts.User

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

  # get_user_by_username/1

  # get_user_by_username_and_password/2

  # register/?

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
