defmodule Helpers.NotImplement do
  @moduledoc """
  抛出未实现的错误（后期可能会引入优先级/前置任务之类的）。
  """
  defexception [message: "Not Implement"]
end
