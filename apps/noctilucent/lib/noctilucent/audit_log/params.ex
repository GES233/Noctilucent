defmodule Noctilucent.AuditLog.Params do
  @moduledoc """
  返回日志操作所需的验证参数。
  """

  @params %{
    account: %{
      # 用户自发的动作
      "user.login" => ~w(user_id),
      "user.logout" => ~w(user_id),
      "user.sign_in" => ~w(username),
      "user.update_info.nickname" => ~w(user_id nickname),
      "user.update_info.gender" => ~w(user_id gender),
      "user.update_info.info" => ~w(user_id info),
      "user.freeze" => ~w(user_id),
      "user.delete_account" => ~w(user_id),
      # 管理员对用户的管理
    }
  }

    @doc """
  通过领域以及动作返回所需的参数。
  """
  def by_scope_and_verb(scope, verb) do
    case by_scope(scope) do
      {:ok, actions} -> cond do
        verb in actions -> {:ok, actions[verb]}
        true -> {:error, :not_found}
      end
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  @doc """
  返回领域下所有的动作及其对应的参数。
  """
  def by_scope(scope) do
    cond do
      scope in get_params() -> {:ok, get_params()[scope]}
      true -> {:error, :not_found}
    end
  end

  defp get_params(), do: @params
end
