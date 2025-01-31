defmodule Noctilucent.Rooms.Room do
  use Ecto.Schema

  schema "rooms" do
    field :name, :string
    field :description, :string
    field :exits, :map
  end
end
