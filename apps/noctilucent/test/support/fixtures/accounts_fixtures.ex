defmodule Noctilucent.AccountsFixtures do
  @moduledoc """
  这个模块定义了用于通过 `Noctilucent.Accounts`
  上下文创建实体的测试辅助函数。
  """

  alias Noctilucent.{Accounts, AuditLog}

  def unique_username, do: "User#{Base.encode16(:crypto.strong_rand_bytes(4))}"
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
    {complete, attrs} =
      attrs
      |> Map.new()
      |> Map.pop(:complete, false)

    user_param = valid_user_attribute(attrs)

    {:ok, user} = Accounts.register_user(AuditLog.system(:test), user_param)

    if complete do
      complete(user)
    else
      user
    end
  end

  defp complete(user) do
    audit_log = AuditLog.system(:test)

    {:ok, user} = Accounts.change_user_nickname(%{audit_log | user: user}, "只因美")

    {:ok, user} = Accounts.change_user_gender(%{audit_log | user: user}, :non_bisexual)

    {:ok, user} = Accounts.change_user_info(%{audit_log | user: user}, "这是一段简介")

    # [TODO) 完成头像填充
    # {:ok, user} = Accounts.change_user_avater(%{audit_log | user: user}, "https://example.com/avater.jpg")

    user
  end
end

# defmodule Noctilucent.AccountsFixturesTest do
#   use Noctilucent.DataCase

#   # alias Noctilucent.Accounts
#   import Noctilucent.AccountsFixtures

#   describe "user_fixture/1" do
#     test "默认情况" do
#       username = unique_username()

#       user = user_fixture(username: username, complete: false)

#       assert user.id != nil
#       assert user.username == username
#     end

#     test "补全" do
#       user = user_fixture()

#       assert user.info == "这是一段简介"
#       assert user.nickname == "只因美"
#     end
#   end
# end
