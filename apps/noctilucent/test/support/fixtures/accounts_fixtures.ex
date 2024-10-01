defmodule Noctilucent.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Noctilucent.Accounts` context.
  """

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
    {:ok, user} =
      attrs
      |> valid_user_attribute()
      |> Noctilucent.Accounts.register_user()

    user
  end

  # TODO:
  # Add user_token_fixture
  # session/token
end
