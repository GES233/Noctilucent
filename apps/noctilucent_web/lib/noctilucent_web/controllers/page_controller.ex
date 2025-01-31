defmodule NoctilucentWeb.PageController do
  use NoctilucentWeb, :controller

  def home(conn, _params) do
    # 主页一般是定制的，所以跳过默认的应用布局。
    render(conn, :home, layout: false)
  end

  def components(conn, params) do
    params |> IO.inspect(label: :conn_params)

    # 如果说客户端返回其他请求的话，需不需要在这里加点啥

    # Used for `table` demo
    memes = [
      %{name: "曼波", origin: "赛马娘"},
      %{name: "哈基米", origin: "爱猫TV"},
      %{name: "叮咚鸡", origin: "张核子"},
      %{name: "牢大", origin: "科比"},
      %{name: "胖猫", origin: "四川水鬼"},
      %{name: "ccb", origin: "otto"}
    ]

    form = []

    render(
      conn,
      :components,
      subtitle: "Subtitle",
      memes: memes,
      form: form
    )
  end
end
