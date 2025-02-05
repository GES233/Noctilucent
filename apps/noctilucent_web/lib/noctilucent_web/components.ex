defmodule NoctilucentWeb.Components do
  @moduledoc false

  def common do
    quote do
      use Phoenix.Component

      alias Phoenix.LiveView.JS
      use Gettext, backend: NoctilucentWeb.Gettext
    end
  end

  def pico, do: quote(do: use Phoenix.Component)

  def all do
    quote do
      import NoctilucentWeb.{
        FlashComponents,
        ModalComponents,
        FormComponents,
        ShowComponents,
        ErrorComponents
      }
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
