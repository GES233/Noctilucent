defmodule Noctilucent.AuditLogTest do
  # 涉及到数据库的，无脑引入就行了
  use Noctilucent.DataCase

  import Noctilucent.AccountsFixtures
  alias Noctilucent.AuditLog

  describe "audit!/3" do
    # ...

    test "检验参数" do
      audit_log = %AuditLog{ip_addr: {127, 0, 0, 1}, user_agent: ""}

      assert_raise AuditLog.Context.InvalidError, ~r/username/, fn ->
        AuditLog.audit!(audit_log, :account, "user.sign_up", %{})
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
