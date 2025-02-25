defmodule Noctilucent.AccountsTest do
  use Noctilucent.DataCase

  alias Noctilucent.{Accounts, AuditLog}
  import Noctilucent.AccountsFixtures

  describe "查询用户" do
    test "list_users/0" do
      length = 16

      for _ <- 1..length do
        user_fixture()
      end

      assert length(Accounts.list_users()) == length
    end

    test "get_user!/1" do
      user = user_fixture()

      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by_username/1" do
      # ...
    end

    test "get_user_by_username_and_password/2" do
      # ...
    end
  end

  describe "Accounts.register_user/2" do
    test "使用合法的用户名与密码注册" do
      {:ok, user} =
        Accounts.register_user(AuditLog.system(:test), %{
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
      {:error, changeset} =
        Accounts.register_user(AuditLog.system(:test), %{})

      assert changeset.valid? == false
    end

    test "存在重复用户" do
      {:ok, _user_1} =
        Accounts.register_user(AuditLog.system(:test), %{
          username: "jntm",
          password: "cxk0802"
        })

      {:error, changeset} =
        Accounts.register_user(AuditLog.system(:test), %{
          username: "jntm",
          password: "iKUNloveBasketball"
        })

      assert changeset.valid? == false
    end
  end

  describe "登录与登录（事物日志层面）" do
    # ...
  end

  describe "更新用户信息" do
    setup do
      %{audit_log: AuditLog.system(:test, %{user: user_fixture()})}
    end

    test "合法的用户名", %{audit_log: audit_log} do
      {:ok, user_with_new_username} = Accounts.change_username(audit_log, "OMGItsJntm")

      assert user_with_new_username.username == "OMGItsJntm"
    end

    test "非法的用户名", %{audit_log: audit_log} do
      # update_username_with_invalid_format
      {:error, iv_changeset} =
        Accounts.change_username(
          audit_log,
          "ItIsAValidUsernameItIsTooLooooong"
        )

      assert iv_changeset.valid? == false
      # TODO: 对更详细的信息进行断言
    end

    test "重复的用户名", %{audit_log: audit_log} do
      # update_username_cause_collide
      _user = user_fixture(%{username: "1234"})

      {:error, collide_changeset} =
        Accounts.change_username(audit_log, "1234")

      assert collide_changeset.valid? == false
    end

    test "昵称", %{audit_log: audit_log} do
      {:ok, user_with_new_nickname} = Accounts.change_user_nickname(audit_log, "迎面走来的baby")

      assert user_with_new_nickname.nickname == "迎面走来的baby"
    end

    test "性别的可见性", %{audit_log: _audit_log} do
      #
    end

    test "性别本体", %{audit_log: _audit_log} do
      #
    end

    test "个人信息", %{audit_log: _audit_log} do
      #
    end
  end
end
