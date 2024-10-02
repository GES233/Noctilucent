defmodule Noctilucent.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Noctilucent.Accounts` context.
  """

  alias Noctilucent.{Accounts, AuditLog}

  def unique_username, do: "User#{System.unique_integer()}iKUNforwever"
  def password, do: "cxkjntm"

  def valid_user_attribute(attrs \\ %{}) do
    Enum.into(attrs, %{
      username: unique_username(),
      password: password()
    })
  end

  @doc """
  创建一个用户。
  """
  def user_fixture(attrs \\ %{}) do
    {complete, attrs} = attrs |> Map.new() |> Map.pop(:complete, true)

    user_param =
      attrs
      |> valid_user_attribute()

    {:ok, user} = Accounts.register_user(AuditLog.blank(), user_param)

    if complete do
      complete(user)
    else
      user
    end
  end

  def complete(user) do
    # [TODO) 完成填充
    # 包括昵称、性别、简介以及头像
    user
  end
end
