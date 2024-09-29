defmodule NoctilucentWeb.PageHTML do
  @moduledoc """
  这个模块包括了将要被 PageController 渲染的页面。

  可以通过 "page_html/" 来看可用的模板。
  """
  use NoctilucentWeb, :html

  embed_templates "page_html/*"
end
