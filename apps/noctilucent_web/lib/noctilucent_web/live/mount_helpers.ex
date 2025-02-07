defmodule NoctilucentWeb.MountHelpers do
  import Phoenix.Component

  alias Noctilucent.Accounts
  alias NoctilucentWeb.RequestContext

  def assign_default(socket, session) do
    socket
    |> assign_current_user(session)
    |> RequestContext.put_audit_context()
  end

  defp assign_current_user(socket, session) do
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(session["user_token"] || "")
    end)
  end
end
