defmodule Noctilucent.Rooms do
  @moduledoc """
  This module is responsible for managing the rooms in the game.
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
