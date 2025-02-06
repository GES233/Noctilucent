defmodule NoctilucentWeb.NclComponents.LayoutComponent do
  # 展示

  use NoctilucentWeb.Components.Salad
  use NoctilucentWeb.Components, :salad

  import NoctilucentWeb.ShowComponents, only: [icon: 1]

  def title(assigns) do
    # TODO:
    # 实现各种效果
    ~H"""
      <title><%= assigns[:title] %></title>
      <meta name="description" content={assigns[:description]} />
    """
  end

  def ncl_icon(assigns) do
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

  def user_current(%{current_user: current_user} = assigns) do
    IO.inspect(current_user)

    user_current(Map.delete(assigns, :current_user))
  end

  def user_current(assigns) do
    # 如果有 assigns[:current_user]，则展示用户信息
    # 否则：展示登录按钮
    ~H"""
    <.dropdown_menu>
      <.dropdown_menu_trigger>
        <.button variant="ghost" size="icon">
          <.avatar>
            <.avatar_image src="https://github.com/shadcn.png" />
            <.avatar_fallback class="bg-primary text-white">Guest</.avatar_fallback>
          </.avatar>
        </.button>
      </.dropdown_menu_trigger>
      <.dropdown_menu_content align="end">
        <.menu class="w-56">
        <!--这部分要改成用户的昵称，点击就可以跳转到主页-->
          <.menu_label class="px-8 text-base">@<%= dgettext("user", "Account") %></.menu_label>
          <.menu_separator />
          <.menu_group>
            <.menu_item>
              <.icon name="hero-user" class="mr-2 h-4 w-4" />
              <span><%= dgettext("user", "Profile") %></span>
              <.menu_shortcut>⌘P</.menu_shortcut>
            </.menu_item>
            <.menu_item>
              <.icon name="hero-envelope" class="mr-2 h-4 w-4" />
              <span><%= dgettext("user", "Message") %></span>
              <.menu_shortcut>⌘B</.menu_shortcut>
            </.menu_item>
            <.menu_item>
              <.icon name="hero-cog-6-tooth" class="mr-2 h-4 w-4" />
              <span><%= dgettext("user", "Settings") %></span>
              <.menu_shortcut>⌘S</.menu_shortcut>
            </.menu_item>
            <.menu_separator />
            <!--关于这部分其实不算很重要了-->
            <.menu_item>
              <.icon name="hero-users" class="mr-2 h-4 w-4" />
              <span>Room</span>
            </.menu_item>
            <.menu_item disabled>
              <.icon name="hero-plus" class="mr-2 h-4 w-4" />
              <span>New room</span>
              <.menu_shortcut>⌘T</.menu_shortcut>
            </.menu_item>
            <.menu_separator />
            <.menu_item>
              <.icon name="hero-x-mark" class="mr-2 h-4 w-4" />
              <span><%= dgettext("user", "Log out") %></span>
              <.menu_shortcut>⌘Q</.menu_shortcut>
            </.menu_item>
        </.menu_group>
        </.menu>
      </.dropdown_menu_content>
    </.dropdown_menu>
    """
  end

  # defp get_avatar_path_from_user(user) do
  #   # 如果用户有头像，则返回头像路径
  #   # 否则：返回默认头像路径
  # end
end
