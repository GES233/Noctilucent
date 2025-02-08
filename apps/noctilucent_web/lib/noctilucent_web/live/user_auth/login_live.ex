defmodule NoctilucentWeb.LoginLive do
  use NoctilucentWeb, :live_view

  alias Noctilucent.Accounts
  # alias NoctilucentWeb.UserAuth

  def render(assigns) do
    ~H"""
    """
  end

  def mount(params, session, socket) do
    do_mount(params, session, MountHelpers.assign_default(socket, session))
  end

  def do_mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:page_title, "Login")
    }
  end

  # def handle_event/3
end
