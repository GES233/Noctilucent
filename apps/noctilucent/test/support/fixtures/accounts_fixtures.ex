defmodule Noctilucent.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Noctilucent.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        avater: "",
        current: "🐔",
        gender: :male,
        gender_visible: true,
        hashed_password: Bcrypt.hash_pwd_salt("cxkjntm"),
        info: "这是简介",
        nickname: "全民制作人🐔",
        status: :normal,
        username: "iKUNforever"
      })
      |> Noctilucent.Accounts.create_user()

    user
  end

  # TODO:
  # Add user_token_fixture
  # session/token
end
