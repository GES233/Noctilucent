defmodule Noctilucent.Rooms do
  @moduledoc """
  用人话来讲就是连麦的房间。

  主要还是考虑房间的创立、删除、以及实施通信。

  至于成员的准入策略以及权限管理，可能会交给子模块，但是这里先不管。
  """

  @type room :: %{name: String.t(), description: String.t(), exits: %{String.t() => String.t()}}

  @spec new_room(String.t(), String.t(), %{String.t() => String.t()}) :: room
  def new_room(name, description, exits) do
    %{name: name, description: description, exits: exits}
  end

  @spec get_room(room, String.t()) :: String.t()
  def get_room(room, direction) do
    room.exits[direction]
  end
end
