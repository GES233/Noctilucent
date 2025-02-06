defmodule NoctilucentWeb.SignUpLive do
  use NoctilucentWeb, :live_view

  alias Noctilucent.Accounts

  def render(assigns) do
    ~H"""
    <div class="grid h-screen w-full">
      <div class="flex flex-col">
        <main class="grid flex-1 gap-4 overflow-auto p-4 grid-cols-1 md:grid-cols-2">
          <div class="relative hidden flex-col items-start gap-8 md:flex">
            <.form for={@form} phx-submit="create_item" class="grid w-full items-start gap-6">
              <.form_item>
                <.form_label class="font-bold" error={not Enum.empty?(@form[:username].errors)}>
                  <%= dgettext("user", "Username") %>
                </.form_label>
                <.input
                  field={@form[:username]}
                  type="text"
                  class={error_class(@form[:username])}
                  placeholder={dgettext("user", "unique username")}
                />
                <.form_description>
                  <%= dgettext("user", "This is your public display name.") %>
                </.form_description>
                <.form_message field={@form[:name]} />
              </.form_item>
              <.form_item>
                <.form_label class="font-bold" error={not Enum.empty?(@form[:password].errors)}>
                  <%= dgettext("user", "Password") %>
                </.form_label>
                <.input
                  field={@form[:password]}
                  type="password"
                  class={error_class(@form[:password])}
                  placeholder={dgettext("user", "enter your password")}
                />
              </.form_item>
            </.form>
          </div>
          <div class="p-8">
            <.label>Submitted data</.label>
            <pre class="p-4 bg-gray-50 mt-4 rounded">bla bla</pre>
          </div>
        </main>
      </div>
    </div>
    """
  end

  defp error_class(field) do
    if Enum.empty?(field.errors), do: "", else: "border-destructive text-destructive"
  end

  def mount(_params, session, socket) do
    # TODO: 获得 audit_log

    session |> IO.inspect()

    form = %Accounts.User{} |> Accounts.User.changeset(%{}) |> to_form()

    {:ok, assign(socket, :form, form)}
  end
end
