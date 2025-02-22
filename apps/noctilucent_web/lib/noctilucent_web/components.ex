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
    # 动态加载 components/salad 目录下的所有模块
    components_dir = Path.join(__DIR__, "components/salad")

    components_dir
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".ex"))
    |> Enum.map(&Path.rootname(&1, ".ex"))
    |> Enum.map(fn filename ->
      # 正确生成模块名：NoctilucentWeb.Components.Salad.<ComponentName>
      module_name =
        filename
        |> String.split("_")
        |> Enum.map(&String.capitalize/1)
        |> Enum.join("")

      # 修复模块路径生成逻辑，正确处理文件名到模块名的转换
      module_name
      |> Path.basename(".ex")
      |> Macro.camelize()
      |> then(&Module.concat(NoctilucentWeb.Components, &1))
    end)
    |> Enum.reject(&(&1 in [
      # 其他地方有定义了，不需要再次导入
      NoctilucentWeb.Components.Icon
    ]))
    |> Enum.map(fn module ->
      quote do
        import unquote(module)
      end
    end)
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
