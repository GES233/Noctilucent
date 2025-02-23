defmodule NoctilucentWeb.RequestContext do
  @moduledoc """
  在用户请求时注入 `%AuditLog{}` 作为上下文。
  """

  alias Noctilucent.AuditLog
  alias NoctilucentWeb.UserAuth

  @log_context_name :audit_context

  def put_audit_context(conn_or_socket, opts \\ [])

  def put_audit_context(%Plug.Conn{} = conn, _) do
    Plug.Conn.assign(conn, @log_context_name, get_audit_log(conn))
  end

  # TODO: ensure type
  # Recalled by MountHelpers
  def put_audit_context(socket, _) do
    Phoenix.Component.assign(socket, %{@log_context_name => get_audit_log(socket)})
  end

  def add_ip_addr_without_socket(_socket, _conn_info) do
    # Phoenix.Component.assign(socket, %{@log_context_name => %{ | ip_addr: conn_info.remote_ip}})
  end

  defp get_audit_log(conn_or_socket) do
    extra = case conn_or_socket do
      %Plug.Conn{} ->
        %{
          user_agent: get_ua(conn_or_socket.req_headers),
          ip_addr: get_ip(conn_or_socket)
        }

      %Phoenix.LiveView.Socket{} ->
        %{
          user_agent: Phoenix.LiveView.get_connect_info(conn_or_socket, :user_agent),
          ip_addr: get_ip(conn_or_socket)
        }
    end

    # Get user from phoenix session
    %AuditLog{user: get_user(conn_or_socket)}
    |> struct!(extra)
    # |> IO.inspect(label: :audit_log)
  end

  defp get_ua(headers) do
    case List.keyfind(headers, "user-agent", 0) do
      {_, value} -> value
      _ -> nil
    end
  end

  # TODO: 以下情况将考虑依照配置进行选择

  defp get_ip(%Plug.Conn{} = conn) do
    # 只在配置了 ngnix 的情况才有用
    # 如果有 Client-IP => Client-IP
    # List.keyfind(conn.req_headers, "x-forwarded-for", 0)
    # 如果有 X-Forwarded-For => X-Forwarded-For

    conn.remote_ip
  end

  defp get_ip(socket) do
    # https://github.com/phoenixframework/phoenix/issues/2758#issuecomment-412293586
    # jose 并不打算支持显式的 IP 查找
    %{address: ip} = Phoenix.LiveView.get_connect_info(socket, :peer_data)

    ip
  end

  defp get_user(conn), do: UserAuth.fetch_current_user(conn, [])
end
