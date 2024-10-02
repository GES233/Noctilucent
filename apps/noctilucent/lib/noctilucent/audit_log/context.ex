defmodule Noctilucent.AuditLog.Context do
  @moduledoc """
  负责处理日志的上下文。
  """

  @doc """
  通过领域以及动作返回所需的上下文。
  """
  def by_scope_and_verb(_scope, _verb) do
    {:error, :not_implement}
  end

  @doc """
  返回领域下所有的动作及其对应的上下文。
  """
  def by_scope(_scope) do
    {:error, :not_implement}
  end
end
