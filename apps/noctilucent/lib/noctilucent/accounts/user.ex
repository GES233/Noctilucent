defmodule Noctilucent.Accounts.User do
  @moduledoc """
  用户模型。
  """
  use Ecto.Schema
  import Ecto.Changeset

  # @derive {Inspect, except: [:password]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :info, :string, default: ""
    field :status, Ecto.Enum, values: [:normal, :frozen, :blocked, :deleted], default: :normal
    field :nickname, :string
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :gender, Ecto.Enum, values: [:male, :female, :non_bisexual, :blank], default: :blank
    field :gender_visible, :boolean, default: false
    field :avater, :string, default: ""
    field :current, :string

    has_many :user_token, Noctilucent.Accounts.UserToken

    timestamps()
  end

  ## Changeset

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :nickname,
      :username,
      :hashed_password,
      :gender,
      :gender_visible,
      :avater,
      :status,
      :current,
      :info
    ])
    |> validate_required([
      :nickname,
      :username,
      :hashed_password,
      :gender,
      :gender_visible,
      :avater,
      :status,
      # :current,
      # :info
    ])
  end

  @doc """
  注册用更改表。
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_password()
    |> unique_constraint(:username)
  end

  def validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 40)
    |> validate_format(:password, ~r/[a-zA-Z]/, message: "at least one letter")
    |> prepare_changes(&hash_password/1)
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
    |> delete_change(:password)
  end

  @doc """
  密码更改表。
  """
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    # |> validate_confirmation(:password)
    |> validate_password()
  end

  @doc """
  用户名更改表。
  """
  def username_changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> unsafe_validate_unique(:username, Noctilucent.Repo)
    |> unique_constraint(:username)
    # 纯粹的 ASCII 不能包含空格
    # |> validate_format(:username, ~r//, message: "only ascii characters without space allowed")
  end

  @doc """
  昵称更改表。
  """
  def nickname_changeset(user, attrs) do
    user
    |> cast(attrs, [:nickname])
  end

  @doc """
  「当下」更改表。
  """
  def current_changeset(user, attrs) do
    user
    |> cast(attrs, [:current])

    # [TODO): Validate scope
    # Emoji or empty string
  end

  @doc """
  性别相关数据更改表。
  """
  def gender_changeset(user, attrs) do
    user
    |> cast(attrs, [:gender, :gender_visible])
  end

  @doc """
  状态更改表。
  """
  def status_changeset(user, attrs) do
    user
    |> cast(attrs, [:status])
  end

  @doc """
  信息更改表。
  """
  def info_changeset(user, attrs) do
    user
    |> cast(attrs, [:info])
  end

  def valid_password?(%Noctilucent.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  def validate_password(changeset, password) do
    changeset = cast(changeset, %{password: password}, [:password])

    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :password, "is not valid")
    end
  end
end
