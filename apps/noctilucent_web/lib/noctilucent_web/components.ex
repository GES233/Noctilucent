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

  def phx do
    quote do
      import NoctilucentWeb.{
        FlashComponents,
        ModalComponents,
        ShowComponents,
        ErrorComponents
      }
    end
  end

  def salad do
    # 这里有一个不知名的错误，相关模块会无法加载
    useful_modules =
      if Application.ensure_loaded(:noctilucent_web) == :ok do
        {:ok, modules} = :application.get_key(:noctilucent_web, :modules)

        modules
        |> Enum.filter(&(&1 |> Module.split() |> length() >= 3))
        |> Enum.filter(&(&1 |> Module.split() |> Enum.take(2) == ["NoctilucentWeb", "Components"]))
      else
        __DIR__
        |> Path.join("components/salad")
        |> File.ls!()
        |> Enum.map(&String.split(&1, ".ex") |> List.first())
        |> Enum.map(&Macro.camelize("elixir/noctilucent_web/components/#{&1}"))
        |> Enum.map(&String.to_existing_atom/1)
      end |> Enum.reject(
        &(Enum.member?(
            [
              # Salad 相关
              "Salad", "SaladHelpers",
              # 仅在 Chart 中被用到
              "LiveChart",
              # ShowComponents 中有
              "Icon",
            ],
            &1 |> Module.split() |> List.last()
          )
        )
      )

    # import libs here
    for module <- useful_modules do
      quote do
        import unquote(module)
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
