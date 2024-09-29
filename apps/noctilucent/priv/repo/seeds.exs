# 用于填充数据库的脚本。您可以通过运行来执行：
#
# mix run priv/repo/seeds.exs
#
# 在脚本中，您可以直接读写任何版本库：
#
#   Noctilucent.Repo.insert!(%Noctilucent.SomeSchema{})
#
# 我们建议使用 bang 函数（`insert!` 、 `update!` 等），因为一旦出错，它们就会失败。
# （关于这种函数名的命名范例，在不同的语言有不同的叫法，
#   在 Julia 里被叫做「有副作用的函数」，因为其会修改传入
#   参数的内容。但是 Elixir 本身变量不可变，并不符合上面
#   的定义。因此按照 bang 函数来命名。）
