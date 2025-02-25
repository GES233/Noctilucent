defmodule Noctilucent.AuditLogTest do
  use Noctilucent.DataCase

  import Noctilucent.AccountsFixtures
  alias Noctilucent.AuditLog

  describe "audit!/3" do
    setup do: %{log: AuditLog.system(:test)}

    # test "简单插入日志" do
    #   # 具体的情景还没想好
    #   # audit_log = AuditLog.audit!(%AuditLog{ip_addr: {127, 0, 0, 1}, user_agent: ""})
    # end

    test "类别相关", %{log: audit_log} do
      assert_raise AuditLog.Context.UnmatchQuery, ~r/foo/, fn ->
        AuditLog.audit!(audit_log, :foo, "bar", %{})
      end
    end

    test "缺乏参数", %{log: audit_log} do
      assert_raise AuditLog.Context.InvalidError, ~r/username/, fn ->
        AuditLog.audit!(audit_log, :account, "user.sign_up", %{})
      end
    end

    test "多余的上下文", %{log: audit_log} do
      assert_raise AuditLog.Context.InvalidError, ~r/foo/, fn ->
        AuditLog.audit!(audit_log, :account, "user.sign_up", %{
          username: "ABCD",
          user_id: "a0784b26-b410-498f-914d-0f57ee9618d9",
          foo: "bar"
        })
      end
    end
  end

  describe "multi/5" do
    test "通过参数实现" do
      # ...
    end

    test "通过回调函数实现" do
      # ...
    end
  end

  describe "查询" do
    setup do
      _user = user_fixture()

      # TODO: 插入一系列事务
    end

    # ...
  end
end
