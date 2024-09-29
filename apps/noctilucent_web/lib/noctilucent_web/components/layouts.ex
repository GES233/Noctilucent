defmodule NoctilucentWeb.Layouts do
  @moduledoc """
  这个模块包括你的应用用到的不同的布局。

  在 "layouts" 目录下可以看到所有可用的模板。
  `root` 布局是作为应用程序路由器的一部分渲染的骨架，
  在 `use NoctilucentWeb, :controller` 以
  及 `use NoctilucentWeb, :live_view` 中，
  `app` 布局被设置为默认布局。
  """
  use NoctilucentWeb, :html

  embed_templates "layouts/*"
end
