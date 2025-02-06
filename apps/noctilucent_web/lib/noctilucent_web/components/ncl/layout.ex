defmodule NoctilucentWeb.NclComponents.LayoutComponent do
  # 展示

  use NoctilucentWeb.Components, :pico

  def icon(assigns) do
    ~H"""
    <div class="flex items-center">
      <a href="/">
        <span class="font-medium leading-6 text-ncl_twi_light font-lumiere-polis font-italic [text-shadow:_0_0_2px_rgba(255,255,255,0.8),0_0_5px_rgba(255,255,255,0.6),0_0_9px_rgba(173,216,230,0.5);]">
          NOCTILUCENT
        </span>
      </a>
    </div>
    """
  end

  def user_current(assigns) do
    # 如果有 assigns[:current_user]，则展示用户信息
    # 否则：展示登录按钮
    ~H"""
    <div class="flex items-center">
      <%= if @current_user do %>
        <div class="flex items-center">
          <a href="/">
            <img src="{@current_user.avatar_url}" class="w-8 h-8 rounded-full" alt="{@current_user.username}">
          </a>
          <a href="/" class="ml-2 text-ncl_twi_light font-medium">
            <%= @current_user.name %>
          </a>
        </div>
      <% else %>
        <a href="/" class="text-ncl_twi_light font-medium">
          登录
        </a>
      <% end %>
    </div>
    """
  end
end
