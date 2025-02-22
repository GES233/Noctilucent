defmodule NoctilucentWeb.UserLive.Show do
  # use NoctilucentWeb, :live_view

  # alias Noctilucent.Accounts

  # @impl true
  # def mount(_params, _session, socket) do
  #   {:ok, socket}
  # end

  # @impl true
  # # id 太拟人了，后面换成 username
  # def handle_params(%{"id" => id}, _, socket) do
  #   {:noreply,
  #    socket
  #    |> assign(:page_title, page_title(socket.assigns.live_action))
  #    |> assign(:user, Accounts.get_user!(id))}
  # end

  # def handle_params(%{"username" => username}, _, socket) do
  #   {:noreply,
  #    socket
  #    |> assign(:page_title, page_title(socket.assigns.live_action))
  #    |> assign(:user, Accounts.get_user_by_username(username))}
  # end

  # defp page_title(:show), do: "Show User"
  # defp page_title(:edit), do: "Edit User"
end
