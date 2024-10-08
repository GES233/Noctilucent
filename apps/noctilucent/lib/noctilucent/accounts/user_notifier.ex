defmodule Noctilucent.Accounts.UserNotifier do
  @moduledoc """
  向用户（指操作账户的自然人而非账户）发送消息。

  ### Why?

  因为在内网部署的关系，所以没有办法采用业界常用的邮件或手机的方式。

  也因为这一层原因，没有选择 `phx.gen.auth` 的功能而重新造轮子
  （虽然大多数业务逻辑都是纯抄的）。

  具体来说，就是让网站的管理员以及邀请人（如果有引入邀请机制的话）
  来充当 `deliver` 的角色。

  这种策略确实比较恶心人的，不过也没有办法，如果骂的人比较多的话那我就砍掉了。
  就改成那种密码没了就是没了，只能找管理员重新把这个用户的密码换掉的方式。

  也确实很恶心人，需要引入消息（网站向用户发送消息）。

  ### How?

  目前考虑有两种方式。一是网页提醒，二是向管理员的后台（包括网页以及终端）发送消息。

  不需要考虑时间，因为事主会自行通过其他渠道联系的。
  """

  @doc """
  执行具体的寄送操作。

  - `recipient` 发送消息的账号
  - `subject` 消息标题
  - `content` 内容本身
  - `opts` 一堆参数
    - `:via` 发送的方式
  """
  def deliver(_recipient, _subject, content, _opts \\ []) do
    content |> IO.puts()
  end
end
