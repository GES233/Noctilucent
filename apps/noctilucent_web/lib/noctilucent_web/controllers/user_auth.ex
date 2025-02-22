defmodule NoctilucentWeb.UserAuth do
  import Plug.Conn
  alias Noctilucent.Accounts.UserToken

  @doc """
  登录已经注册的用户。
  """
  def login_user(conn, user) do
    {:ok, token} = UserToken.build_session_token(user, :storage_user)

    conn
    |> renew_session(:all)
    |> put_session(:user_token, token)
    # Bytepack 还有个关于 live_socket_id 的逻辑，但我没看懂
  end

  # 避免被攻击，删除除保留项之外（如声明）的所有会话数据。
  defp renew_session(conn, :all) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp renew_session(conn, key) do
    value = get_session(conn, key)

    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> put_session(key, value)
  end

  @doc """
  登出用户。
  """
  # 删除或无效化 token
  def logout_user(conn, _user) do
    conn
  end

  @doc """
  从会话中获得当前用户。
  """
  def fetch_current_user(conn, _opts) do
    with user_token when is_binary(user_token) <- get_session(conn, :user_token),
    {:ok, user} <- UserToken.verify_session_token_query(user_token, :storage_user) do
      assign(conn, :current_user, user)
    else
      _ -> conn
    end
  end
end
