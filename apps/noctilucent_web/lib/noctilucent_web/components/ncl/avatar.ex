defmodule NoctilucentWeb.NclComponents.AvatarComponents do
  use NoctilucentWeb.Components, :pico
  # 头像组件

  attr :avatar_id, :string
  attr :size, :string
  attr :username, :string, required: false

  def avatar(assigns) do
    ~H"""
    <img
      class="w-16 h-16 rounded-full object-cover border-2 border-gray-100"
      src={@avatar_id <> "@" <> @size}
      alt={@user.username || "avater"}
    />
    """
  end
end
