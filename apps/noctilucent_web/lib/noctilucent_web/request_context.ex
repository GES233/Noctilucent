defmodule NoctilucentWeb.RequestContext do
  @moduledoc """
  在用户请求时注入 `%AuditLog{}` 作为上下文。
  """

  alias Noctilucent.AuditLog

  @log_context_name :audit_context

  def put_audit_context(conn_or_socket, opts \\ [])

  def put_audit_context(%Plug.Conn{} = conn, _) do
    Plug.Conn.assign(conn, @log_context_name, get_audit_log(conn))
  end

  def put_audit_context(%Phoenix.LiveView.Socket{} = socket, _) do
    Phoenix.Component.assign(socket, @log_context_name, get_audit_log(socket))
  end

  defp get_audit_log(conn_or_socket) do
    extra = case conn_or_socket do
      %Plug.Conn{} ->
        %{
          user_agent: get_ua(conn_or_socket.req_headers),
          ip_addr: get_ip(conn_or_socket)
        }

      %Phoenix.LiveView.Socket{} ->
        if ua = Phoenix.LiveView.get_connect_info(conn_or_socket, :user_agent) do
          ip = get_ip(Phoenix.LiveView.get_connect_info(conn_or_socket, :x_headers) || [])

          %{ip_addr: ip, user_agent: ua}
        else
          %{}
        end
    end

    %AuditLog{user: get_user(conn_or_socket)}
    |> struct!(extra)
    |> IO.inspect(label: :audit_log)
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

  defp get_ip(_socket) do
    raise Helpers.NotImplement
  end

  defp get_user(%Plug.Conn{assigns: %{current_user: user}}), do: user
  # Add live view support
  defp get_user(_), do: nil
end
