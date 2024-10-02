defmodule NoctilucentWeb.RequestContext do
  alias Noctilucent.AuditLog

  @log_context_name :audit_context

  def put_audit_context(conn_or_socket, opts \\ [])

  def put_audit_context(%Plug.Conn{} = conn, _) do
    Plug.Conn.assign(conn, @log_context_name, %AuditLog{})
  end

  def put_audit_context(%Phoenix.LiveView.Socket{} = socket, _) do
    socket
    # Phoenix.LiveView.assign(socket, @log_context_name, %AuditLog{})
  end

  # get_ip/1
end
