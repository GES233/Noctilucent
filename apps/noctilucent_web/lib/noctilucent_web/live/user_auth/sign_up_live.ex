defmodule NoctilucentWeb.SignUpLive do
  use NoctilucentWeb, :live_view

  require Logger
  alias Noctilucent.Accounts

  defp error_class(field) do
    if Enum.empty?(field.errors), do: "", else: "border-destructive text-destructive"
  end

  def mount(_params, _session, %{current_usr: _} = socket) do
    {:ok, push_navigate(socket, to: ~p"/")}
  end

  def mount(_params, session, socket) do
    # TODO: 获得 audit_log

    socket
    |> MountHelpers.assign_default(session)

    {
      :ok,
      socket
      |> assign(:page_title, "Sign Up")
      |> assign(:form, put_form())
    }
  end

  defp put_form() do
    %Accounts.User{}
    |> Accounts.User.changeset(%{})
    |> to_form()
  end

  def handle_event(event, params, socket) do
    Logger.warning(unhandled_event: {__MODULE__, event, params})

    {
      :noreply,
      socket
      |> put_flash(:info, event)
    }
  end
end
