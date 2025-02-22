defmodule Noctilucent.AccountsTest do
  use Noctilucent.DataCase

  alias Noctilucent.{Accounts, AuditLog}
  import Noctilucent.AccountsFixtures

  describe "Accounts.register_user/2" do
    test "register with valid username and password" do
      {:ok, user} =
        Accounts.register_user(gen_audit(), %{username: "jntm", password: "cxk0802"})

      assert user.username == "jntm"
      assert is_binary(user.hashed_password)
      assert is_nil(user.password)

      [audit_log] = AuditLog.list_by_user(user.id)

      assert audit_log.scope == :accounts
      assert audit_log.verb == "user.sign_up"
    end

    test "register with invalid username and password" do
      # TODO
    end

    test "register with collide users" do
      # TODO
    end
  end

  describe "update user's info" do
    test "update username" do
      # update_username_with_valid_format

      # update_username_with_invalid_format

      # update_username_cause_collide
    end

    test "update nickname" do
      #
    end

    test "update gender" do
      #
    end

    test "update info" do
      #
    end
  end
end
