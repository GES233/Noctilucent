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
          ip_addr: get_ip(conn_or_socket.req_headers)
        }

      %Phoenix.LiveView.Socket{} ->
        if info = Phoenix.LiveView.get_connect_info(conn_or_socket) do
          ip = get_ip(info[:x_headers] || [])

          %{ip_addr: ip, user_agent: info[:user_agent]}
        else
          %{}
        end
    end

    %AuditLog{user: get_user(conn_or_socket)}
    |> struct!(extra) |> IO.inspect()
  end

  defp get_ua(headers) do
    case List.keyfind(headers, "user-agent", 0) do
      {_, value} -> value
      _ -> nil
    end
  end

  defp get_ip(headers) do
    # [TODO) Edge has not this header.
    IO.inspect(List.keyfind(headers, "x-forwarded-for", 0), label: :ip)

    with {_, ip} <- List.keyfind(headers, "x-forwarded-for", 0),
        [ip | _] = String.split(ip, ",") do
      ip
    else
      _ ->
        nil
    end
  end

  defp get_user(%Plug.Conn{assigns: %{current_user: user}}), do: user
  # Add live view support
  defp get_user(_), do: nil
end
