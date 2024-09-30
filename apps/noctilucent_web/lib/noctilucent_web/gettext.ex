defmodule NoctilucentWeb.Gettext do
  # 不翻译了
  @moduledoc """
  A module providing Internationalization with a gettext-based API.

  By using [Gettext](https://hexdocs.pm/gettext),
  your module gains a set of macros for translations, for example:

      use Gettext, backend: NoctilucentWeb.Gettext

      # Simple translation
      gettext("Here is the string to translate")

      # Plural translation
      ngettext("Here is the string to translate",
               "Here are the strings to translate",
               3)

      # Domain-based translation
      dgettext("errors", "Here is the error message to translate")

  See the [Gettext Docs](https://hexdocs.pm/gettext) for detailed usage.
  """
  use Gettext.Backend, otp_app: :noctilucent_web

  @doc """
  返回默认语言。

  当前是简体中文（`zh_CN`）。
  """
  def default_lang(), do: Gettext.get_locale(NoctilucentWeb.Gettext)
end
