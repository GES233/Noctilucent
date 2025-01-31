defmodule NoctilucentWeb.ErrorComponents do
  use NoctilucentWeb.Components, :common
  alias NoctilucentWeb.ShowComponents

  @doc """
  生成通用错误信息。
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600">
      <ShowComponents.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" /> <%= render_slot(
        @inner_block
      ) %>
    </p>
    """
  end

  @doc """
  通过 gettext 翻译某条错误。
  """
  def translate_error({msg, opts}) do
    # 当使用 gettext 时，我们一般吧那些我们想要翻译的字符串当成静态参数传递过去：
    #
    #     # 翻译复数（是 plural 而非 conplex num.）形式的文件
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # 然而来自于我们的表单以及 API 的错误信息是动态生成的，因此我们需要
    # 通过调用有着我们的 gettext 后端作为 Gettext 的第一个参数来翻译它们。
    # 在 errors.po 文件翻译依旧可行（我们再次使用 "errors" 领域）。
    if count = opts[:count] do
      Gettext.dngettext(NoctilucentWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(NoctilucentWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  从一堆错误里翻译某个字段的错误。
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
