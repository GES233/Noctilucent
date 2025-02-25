defmodule Noctilucent.AccountsTest do
  use Noctilucent.DataCase

  alias Noctilucent.{Accounts, AuditLog}
  import Noctilucent.AccountsFixtures

  describe "Accounts.register_user/2" do
    test "使用合法的用户名与密码注册" do
      {:ok, user} =
        Accounts.register_user(%AuditLog{ip_addr: {127, 0, 0, 1}, user_agent: "Elixir Test"}, %{
          username: "jntm",
          password: "cxk0802"
        })

      assert user.username == "jntm"
      assert is_binary(user.hashed_password)
      assert is_nil(user.password)

      [audit_log] = AuditLog.list_by_user(user)

      assert audit_log.scope == :account
      assert audit_log.verb == "user.sign_up"
    end

    test "使用非法的用户名或密码注册" do
      # TODO
    end

    test "存在重复用户" do
      # TODO
    end
  end

  describe "登录与登录（事物日志层面）" do
    # ...
  end

  describe "更新用户信息" do
    setup do
      user = user_fixture()

      audit_log = %AuditLog{user: user, ip_addr: {127, 0, 0, 1}, user_agent: "Elixir Test"}

      %{audit_log: audit_log}
    end

    test "用户名", %{audit_log: _audit_log} do
      # update_username_with_valid_format

      # update_username_with_invalid_format

      # update_username_cause_collide
    end

    test "昵称", %{audit_log: audit_log} do
      {:ok, user_with_new_nickname} = Accounts.change_user_nickname(audit_log, "迎面走来的baby")
      assert user_with_new_nickname.nickname == "迎面走来的baby"
    end

    test "性别" do
      #
    end

    test "个人信息" do
      #
    end
  end
end
