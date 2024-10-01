defmodule NoctilucentWeb.RequestContext do
  alias Noctilucent.AuditLog

  @log_context_name :audit_context

  def put_audit_log(conn_or_socket, opts \\ [])

  def put_audit_context(%Plug.Conn{} = conn, _) do
    Plug.assign(conn, @audit_context, %AuditLog{})
  end

  def put_audit_context(%Phoenix.LiveView.Socket{} = socket, _) do
    Phoenix.LiveView.assign(socket, @audit_context, %AuditLog{})
  end

  # get_ip/1
end
