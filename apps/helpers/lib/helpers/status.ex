defmodule Helpers.Status do
  @moduledoc """
  提供通用的状态。

  除了拥有默认值为 `c` 的 Map ，`Status` 还拥有：
  * `operate_when_not_match/1`
  * `get_valid_values/0`
  * `get_default_value/0`
  * `value/1`
  * `valid?/1`
  * `under/2`
  * `create/1`

  ## Examples

      iex> defmodule Status do
      ...>   use Helpers.Status, [:a, :b, c: :default]
      ...> end
      iex> status = Status.create()
      %Status{value: :c}
      iex> Status.valid?(status)
      true
      iex> invalid = %Status{value: :invalid}
      %Status{value: :invalid}
      iex> Status.valid?(invalid)
      false
  """

  @spec __using__(list()) :: {:__block__, [], [{any(), any(), any()}, ...]}
  @doc false
  defmacro __using__(opts) do
    # 对传入的参数进行最基本的处理
    parse_opts = fn opts ->
      status_without_default = fn option_list ->
        Enum.map(option_list, fn item -> is_atom(item) and item end) |> List.delete(false)
      end

      default_field = fn option_list ->
        Enum.map(option_list, fn item ->
          is_tuple(item) and Tuple.to_list(item) |> List.delete(:default) |> List.flatten()
        end)
        |> Enum.reject(&is_boolean(&1))
        |> List.flatten()
        |> hd
      end

      init_fields = status_without_default.(opts)
      def_value = default_field.(opts)

      if def_value in init_fields do
        [fields: init_fields, default: def_value]
      else
        [fields: [init_fields | [def_value]] |> List.flatten(), default: def_value]
      end
    end

    quote bind_quoted: [opts: parse_opts.(opts)] do
      @type value :: atom()
      @type t :: %__MODULE__{value: value()}
      defstruct [:value]

      import Helpers.Status

      # 可能以后会返回 {:error, :not_match}
      @doc """
      当不匹配时的操作。
      """
      def operate_when_not_match(status), do: status

      @doc """
      返回所有的合法状态。
      """
      def get_valid_values(), do: unquote(opts[:fields])

      @doc """
      返回默认状态。
      """
      def get_default_value(), do: unquote(opts[:default])

      @doc """
      返回状态的值。
      """
      def value(%__MODULE__{value: value}), do: value

      @doc """
      状态是合法状态吗？
      """
      def valid?(status), do: value(status) in get_valid_values()

      @doc """
      状态是否在给定的值中。
      """
      def under(status, state) when is_atom(state) do
        if state in get_valid_values() do
          value(status) == state
        else
          false
        end
      end

      def under(status, state) when is_list(state) do
        value(status) in state
      end

      def under(_status, _state), do: nil

      @doc """
      创建新状态。
      """
      def create(), do: %__MODULE__{value: get_default_value()}
    end
  end
end
