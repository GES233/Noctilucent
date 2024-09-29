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
        avater: "some avater",
        current: "some current",
        gender: :male,
        gender_visible: true,
        hashed_password: "some hashed_password",
        info: "some info",
        nickname: "some nickname",
        status: :normal,
        username: "some username"
      })
      |> Noctilucent.Accounts.create_user()

    user
  end
end
