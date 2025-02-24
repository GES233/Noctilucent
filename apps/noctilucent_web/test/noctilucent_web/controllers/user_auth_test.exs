defmodule NoctilucentWeb.UserAuthTest do
  use NoctilucentWeb.ConnCase

  alias Noctilucent.Accounts
  alias NoctilucentWeb.UserAuth
  import Noctilucent.AccountsFixtures

  setup %{conn: conn} do
    conn = conn
      |> Map.replace!(:secret_key_base, NoctilucentWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{conn: conn, user: user_fixture()}
  end

  describe "login_user/2" do
    test "将用户信息保存到会话中", %{conn: conn, user: user} do
      conn = UserAuth.login_user(conn, user)

      assert token = get_session(conn, :user_token)
      # TODO
      # 可以从 liveview socket 中得到 live_socket_id
      # 将登录与数据库写入绑定
      # assert get_session(conn, :live_socket_id) == "user_sessions:#{token}"
      # assert Accounts.get_user_by_session_token(token)
    end
  end
end
