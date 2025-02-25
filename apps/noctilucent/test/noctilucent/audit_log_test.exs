defmodule Noctilucent.AuditLogTest do
  use Noctilucent.DataCase

  import Noctilucent.AccountsFixtures
  alias Noctilucent.AuditLog

  describe "audit!/3" do
    # test "简单插入日志" do
    #   # 具体的情景还没想好
    #   # audit_log = AuditLog.audit!(%AuditLog{ip_addr: {127, 0, 0, 1}, user_agent: ""})
    # end

    test "检验参数" do
      audit_log = %AuditLog{ip_addr: {127, 0, 0, 1}, user_agent: ""}

      # 缺乏参数
      assert_raise AuditLog.Context.InvalidError, ~r/username/, fn ->
        AuditLog.audit!(audit_log, :account, "user.sign_up", %{})
      end

      # 多了参数
      # ...
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
