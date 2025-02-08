defmodule NoctilucentWeb.SignUpLive do
  use NoctilucentWeb, :live_view
  # TODO: 实现注册功能

  require Logger
  alias Noctilucent.Accounts

  defp error_class(field) do
    if Enum.empty?(field.errors), do: "", else: "border-destructive text-destructive"
  end

  def mount(params, session, socket) do
    do_mount(params, session, MountHelpers.assign_default(socket, session))
  end

  def do_mount(_params, _session, %{current_user: %Accounts.User{}} = socket) do
    {
      :ok,
      socket
      |> put_flash(:info, dgettext("user", "You are already signed in."))
      |> push_navigate(to: ~p"/")
    }
  end

  def do_mount(_params, _session, socket) do

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

  def handle_event("send-sign-form", %{"user" => attrs} = params, socket) do
    case %Accounts.User{} |> Accounts.register_user(attrs) do
      {:ok, _user} -> {
        :ok,
        socket
        # 自动登录（remember_me: true）
      }

      {:error, changeset} ->
        IO.inspect to_form(changeset)

        {
          :noreply,
          socket
          |> assign(
            form: to_form(changeset),
            output: inspect(params, pretty: true, width: 0)
          )
        }
    end
  end
end
