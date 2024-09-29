defmodule NoctilucentWeb.ErrorHTML do
  @moduledoc """
  本模块被您的应用的端点在 HTML 请求出错时所调用。

  请看 config/config.exs 。
  """
  use NoctilucentWeb, :html

  # 如果要自定义错误页面，请取消下面的 embed_templates/1 调用，并在错误目录
  # 中添加对应的页面：
  #
  #   * lib/noctilucent_web/controllers/error_html/404.html.heex
  #   * lib/noctilucent_web/controllers/error_html/500.html.heex
  #
  # embed_templates "error_html/*"

  # 默认情况是根据模板名称渲染纯文本页面。例如， "404.html" 会变成 "Not Found" 。
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
