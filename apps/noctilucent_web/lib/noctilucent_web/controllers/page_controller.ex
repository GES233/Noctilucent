defmodule NoctilucentWeb.PageController do
  use NoctilucentWeb, :controller

  def home(conn, _params) do
    # 主页一般是定制的，所以跳过默认的应用布局。
    render(conn, :home, layout: false)
  end

  def components(conn, params) do
    params |> IO.inspect(label: :conn_params)

    render(conn, :components, subtitle: "Subtitle")
  end
end
