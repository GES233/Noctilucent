defmodule NoctilucentWeb.NclComponents.CardComponents do
  # 卡片容器
  use NoctilucentWeb.Components, :common

  alias Noctilucent.Accounts.User

  @doc """
  用于展现用户信息的悬浮卡片。
  """
  attr :user, User, required: true
  attr :followed, :boolean, default: false

  def user_card(%{user: %User{} = _user} = assigns) do
    ~H"""
    <div class="bg-white shadow-md rounded-lg p-6">
      <slot />
    </div>
    """
  end

  @doc """
  内容卡片（或者叫容器）。
  """
  def context_card(assigns) do
    ~H"""
    <div class="bg-white shadow-md rounded-lg p-6">
      <slot />
    </div>
    """
  end
end
